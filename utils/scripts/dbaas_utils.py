import os
import re
import string
import time
from typing import List

import util
import yaml
from logger import log
from robot.libraries.BuiltIn import BuiltIn
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.by import By

ROBOT_LIBRARY_VERSION = "0.7"


def select_database_instance(
    instance_elem: string,
    click_elem: string,
    alert_elem: string = "//*[contains(.,'AlreadyExists')]",
):
    """To select a valid DB instance from Instance table on Developer view"""
    sl = BuiltIn().get_library_instance("SeleniumLibrary")
    count = sl.find_elements(instance_elem)
    if not count:
        log.error("No Database Instances Available for Selected Account")
    for elem_iter in range(1, len(count) + 1):
        target = "(" + instance_elem + "/td[1]//input)[" + str(elem_iter) + "]"
        instance_name = "(" + instance_elem + "/td[2])[" + str(elem_iter) + "]"
        sl.find_element(target).click()
        element_attribute = sl.find_element(instance_name).get_attribute("innerHTML")
        sl.scroll_element_into_view(click_elem)
        sl.click_element(click_elem)
        try:
            sl.driver.find_element(By.XPATH, alert_elem)
        except NoSuchElementException:
            log.info("returning element : " + element_attribute)
            return element_attribute
    log.error("Database Instance Selection Failed")


def sort_webtable_column(
    sort_elem: string, order: string, attribute: string = "aria-sort"
):
    """To sort Webtable column for given order"""
    sl = BuiltIn().get_library_instance("SeleniumLibrary")
    element = sl.find_element(sort_elem)
    element.click()
    log.info(element.get_attribute(attribute))
    if not order in element.get_attribute(attribute):
        element.click()
        log.info("Element sorted " + order + " order")
    else:
        log.info("Element sorted with " + order + " order already")


def write_yaml_to_textbox(isv: string, target_elem: string):
    """To Import YAML into Openshift"""
    sl = BuiltIn().get_library_instance("SeleniumLibrary")
    file_path = os.getcwd() + "/utils/data/oc_" + isv + "_application.yaml"
    with open(file_path, "r") as f:
        text = f.read()
    element = sl.find_element(target_elem)
    element.click()
    sl.input_text(target_elem, text)


def get_import_application_name(isv: string):
    """To retrieve Application name from input YAML"""
    file_path = os.getcwd() + "/utils/data/oc_" + isv + "_application.yaml"
    try:
        with open(file_path, "r") as f:
            for data in yaml.load_all(f, Loader=yaml.FullLoader):
                return data["metadata"]["name"]
    except yaml.YAMLError as e:
        log.error("Error while parsing data file: " + str(e.context))


def update_service_binding(project_name, pa_name, app_name):
    """To update the Service binding yaml file"""
    binder = os.getcwd() + "/utils/data/oc_source_binding.yaml"
    with open(binder, "r") as fh:
        data = yaml.safe_load(fh)
    data["metadata"] = {}
    data["metadata"]["name"] = project_name + "-" + pa_name
    data["metadata"]["namespace"] = project_name
    data["spec"]["application"]["name"] = app_name
    data["spec"]["services"][0]["name"] = pa_name
    with open(binder, "w") as yaml_file:
        yaml_file.write(yaml.dump(data, default_flow_style=False, sort_keys=False))
    log.info("Updated Service binding!")
    return data["metadata"]["name"]


def create_service_binding(namespace):
    """To Create Service Binding between DB instance to Openshift Application"""
    oc_cli = BuiltIn().get_library_instance("OpenshiftLibrary")
    kind = "ServiceBinding"
    src = "utils/data/oc_source_binding.yaml"
    api_version = "binding.operators.coreos.com/v1alpha1"
    oc_cli.oc_apply(kind, src, api_version, namespace)
    log.info("Create Service binding Successfully!")


def get_quarkus_application_url(console_url, connection):
    """To return application connection URL from console URL"""
    application_url = console_url.replace("console-openshift-console", connection)
    application_url = re.sub(r"/$", "", application_url) + "/fruits.html"
    log.info(application_url)
    return application_url.replace("https", "http")


def create_secret_yaml(isv_lower, valid, namespace):
    """To configure secrets yaml template parameters basis
    input ISV(Database Provider)"""
    secret_temp = "./utils/data/oc_secrets.yaml"
    test_variables = "./test-variables.yaml"
    with open(secret_temp, "r") as sf:
        data = yaml.safe_load(sf)
    with open(test_variables, "r") as sf2:
        variables = yaml.safe_load(sf2)
    global secret_name
    secret_name = (
        str(data["metadata"]["name"])
        + "-"
        + isv_lower
        + "-"
        + str(time.time_ns())[-10:]
    )
    data["metadata"]["name"] = secret_name
    data["metadata"]["namespace"] = namespace
    if "mongo" in isv_lower:
        data["metadata"]["labels"]["atlas.mongodb.com/type"] = "credentials"
        data["stringData"] = variables["MONGO"]
    elif "crunchy" in isv_lower:
        data["stringData"] = variables["CRUNCHY"]
        data["metadata"]["labels"]["db-operator/type"] = "credentials"
    elif "cockroach" in isv_lower:
        data["stringData"] = variables["COCKROACH"]
        data["metadata"]["labels"]["db-operator/type"] = "credentials"
    elif "rds" in isv_lower:
        data["stringData"] = variables["RDS"]
        data["metadata"]["labels"]["db-operator/type"] = "credentials"
    if valid == "False":
        last_key = list(data["stringData"].keys())[-1]
        data["stringData"][last_key] = "invalidData"
    return yaml.dump(data, sort_keys=False)


def create_secret_cli(isv, valid, namespace="redhat-dbaas-operator"):
    """To create the Secret Credentials Resource using the secrets yaml"""
    oc_cli = BuiltIn().get_library_instance("OpenshiftLibrary")
    kind = "Secret"
    src = create_secret_yaml(isv.lower(), valid, namespace)
    api_version = "v1"
    oc_cli.oc_apply(kind, src, api_version)
    log.info("Secret Created successfully!")
    BuiltIn().set_suite_variable("\${SECRET_NAME}", secret_name)


def create_provider_account_yaml(isv_lower, namespace):
    """To configure provider account yaml template parameters basis
    input ISV(Database Provider)"""
    pa_yaml_temp = "./utils/data/oc_provider_account.yaml"
    with open(pa_yaml_temp, "r") as sf:
        data = yaml.safe_load(sf)
    global prov_acc_name
    prov_acc_name = util.get_provider_account_name(isv_lower)
    data["metadata"]["name"] = prov_acc_name
    data["metadata"]["namespace"] = namespace
    data["spec"]["credentialsRef"]["name"] = secret_name
    if "mongo" in isv_lower:
        data["spec"]["providerRef"]["name"] = "mongodb-atlas-registration"
    elif "crunchy" in isv_lower:
        data["spec"]["providerRef"]["name"] = "crunchy-bridge-registration"
    elif "cockroach" in isv_lower:
        data["spec"]["providerRef"]["name"] = "cockroachdb-cloud-registration"
    elif "rds" in isv_lower:
        data["spec"]["providerRef"]["name"] = "rds-registration"
    return yaml.dump(data, sort_keys=False)


def import_provider_account_cli(isv, namespace="redhat-dbaas-operator"):
    """To import a Provider Account using the configured
    Provider Account yaml"""
    oc_cli = BuiltIn().get_library_instance("OpenshiftLibrary")
    kind = "DBaaSInventory"
    src = create_provider_account_yaml(isv.lower(), namespace)
    api_version = "dbaas.redhat.com/v1alpha1"
    oc_cli.oc_apply(kind, src, api_version)
    log.info("Provider Account Imported!")
    BuiltIn().set_suite_variable("\${provaccname}", prov_acc_name)


def deploy_db_instance_cli(isv, project, namespace="redhat-dbaas-operator"):
    """To deploy a DB instance on given namespace for the
    imported provider account"""
    instance_list = retrieve_instances(isv, namespace)
    create_new_project(project)
    project_name = BuiltIn().get_variable_value(r"\${newProject}")
    deploy_instance(project_name, instance_list)


def retrieve_instances(isv, namespace):
    """To retrieve DB instances for Imported Provider Account"""
    inst_list = []
    provider_account = BuiltIn().get_variable_value(r"\${provaccname}")
    if provider_account == "":
        create_secret_cli(isv, "true")
        import_provider_account_cli(isv, namespace)
        provider_account = BuiltIn().get_variable_value(r"\${provaccname}")
    cmd = "oc describe DBaaSInventory/{} -n {}".format(provider_account, namespace)
    while True:
        try:
            result = util.execute_command(cmd)
            res = yaml.safe_load(result)
            if res["Status"]["Conditions"]["Reason"] == "ProviderReconcileInprogress":
                continue
            for instance in result.split("\n"):
                if "Instance ID" in instance:
                    inst_list.append(instance.split(":")[1].strip())
            log.info("Provider account Instances retrieved successfully!")
            return inst_list
        except KeyError:
            continue


def create_new_project(project_name):
    """To create new project to deploy provider account"""
    project_name = util.get_project_name(project_name)
    oc_cli = BuiltIn().get_library_instance("OpenshiftLibrary")
    oc_cli.new_project(project_name)
    BuiltIn().set_suite_variable(r"\${newProject}", project_name)
    log.info("Project Created Successfully")


def deploy_instance(project, instance_list: List[str]):
    """To deploy instance to given project"""
    oc_cli = BuiltIn().get_library_instance("OpenshiftLibrary")
    kind = "DBaaSConnection"
    api_version = "dbaas.redhat.com/v1alpha1"
    for instance_id in instance_list:
        src = create_deploy_instance_yaml(project, instance_id)
        oc_cli.oc_apply(kind, src, api_version)
        counter = 0
        while counter < 5:
            try:
                counter += 1
                instance = BuiltIn().get_variable_value(r"\${instanceName}")
                cmd = "oc describe DBaaSConnection/{} -n {}".format(instance, project)
                result = util.execute_command(cmd)
                res = yaml.safe_load(result)
                if res["Status"]["Conditions"]["Reason"] == "Ready":
                    log.info(
                        "Deployed DBSC Instance Available in Ready Status for Binding"
                    )
                    break
                else:
                    continue
            except:
                continue
        break
    else:
        BuiltIn().fail("Instance Deployment failed")


def create_deploy_instance_yaml(project, instance_id):
    """To create deploy instance yaml"""
    yaml_deploy_instance = "./utils/data/oc_deploy_instance.yaml"
    with open(yaml_deploy_instance, "r") as di:
        data = yaml.safe_load(di)
    global instance_name
    instance_name = util.get_instance_name("cli")
    data["metadata"]["name"] = instance_name
    data["metadata"]["namespace"] = project
    data["spec"]["inventoryRef"]["name"] = BuiltIn().get_variable_value(
        r"\${provaccname}"
    )
    data["spec"]["instanceID"] = instance_id
    BuiltIn().set_suite_variable(r"\${instanceID}", instance_id)
    BuiltIn().set_suite_variable(r"\${instanceName}", instance_name)
    return yaml.dump(data, sort_keys=False)


def check_dbsc_connection(project, instance_id):
    """To verify project contains instance deployed"""
    if instance_id == "" or project == "":
        BuiltIn().fail("Instance Id and Project should present")
    cmd = "oc get DBaaSConnections -n {}".format(project)
    dbsc = util.execute_command(cmd)
    conn_list = []
    for conn in dbsc.split("\n"):
        if not conn.startswith("NAME") and conn != "":
            conn_list.append(conn.split(" ")[0].strip())
    if len(conn_list) > 0:
        for dbsc_inst in conn_list:
            cmd = "oc describe DBaaSConnections/{} -n {}".format(dbsc_inst, project)
            result = util.execute_command(cmd)
            response = yaml.safe_load(result)
            if response["Spec"]["Instance ID"] == instance_id:
                log.info("Given Instance Available on Project Namespace")
                break
        else:
            BuiltIn().fail(
                "Instance not available on the DBSC Connections on the Project namespace"
            )
    else:
        BuiltIn().fail("DBSC Connections are not present for the project: " + project)


def provision_db_instance(isv, deploy_view, default_pa_ns="Yes"):
    """To Provision New DB Instance Under Provider Account.
    Arguments deploy_view and default_pa_ns defines the target namespaces to
    deploy database instance and import provider account respectively"""
    prov_acc_ns = "redhat-dbaas-operator"
    deploy_instance_ns = "redhat-dbaas-operator"
    create_new_project(BuiltIn().get_variable_value(r"\${TEST TAGS}"))
    if default_pa_ns != "Yes":
        prov_acc_ns = BuiltIn().get_variable_value(r"\${newProject}")
    retrieve_instances(isv, prov_acc_ns)
    if "user" in deploy_view.lower():
        deploy_instance_ns = BuiltIn().get_variable_value(r"\${newProject}")
    src = create_provision_instance_yaml(isv, prov_acc_ns, deploy_instance_ns)
    oc_cli = BuiltIn().get_library_instance("OpenshiftLibrary")
    kind = "DBaaSInstance"
    api_version = "dbaas.redhat.com/v1alpha1"
    oc_cli.oc_apply(kind, src, api_version)
    log.info("DB Instance " + BuiltIn().get_variable_value(r"\${instanceName}")
             + "provisioned successfully!")


def create_provision_instance_yaml(isv, prov_acc_ns, deploy_instance_ns):
    """To create provision instance yaml"""
    instance = util.get_instance_name("cli")
    BuiltIn().set_suite_variable(r"\${instanceName}", instance)
    yaml_deploy_instance = "./utils/data/oc_dbaas_instance.yaml"
    with open(yaml_deploy_instance, "r") as provision:
        data = yaml.safe_load(provision)
    data["metadata"]["name"] = instance
    data["metadata"]["namespace"] = deploy_instance_ns
    data["spec"]["name"] = instance
    data["spec"]["inventoryRef"]["name"] = BuiltIn().get_variable_value(r"\${provaccname}")
    data["spec"]["inventoryRef"]["namespace"] = prov_acc_ns
    if "mongo" in isv.lower():
        data["spec"]["otherInstanceParams"]["projectName"] = instance
    print(data)
    return yaml.dump(data, sort_keys=False)

