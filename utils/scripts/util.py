import os
import random
import re
import shutil
import string
import subprocess
import sys
import time

import jinja2
import yaml
from logger import log

ROBOT_LIBRARY_VERSION = "0.1"


def clone_config_repo(**kwargs):
    """
    Helper function to clone git repo
    """
    if "git_username" not in kwargs.keys():
        kwargs["git_username"] = ""

    if "git_password" not in kwargs.keys():
        kwargs["git_password"] = ""

    try:
        if os.path.exists(kwargs["repo_dir"]) and os.path.isdir(kwargs["repo_dir"]):
            shutil.rmtree(kwargs["repo_dir"])
        os.makedirs(kwargs["repo_dir"])
        print("git repo dir '%s' created successfully" % kwargs["repo_dir"])
    except OSError as error:
        print("git repo dir '%s' can not be created." % kwargs["repo_dir"])
        return False

    git_repo_with_credens = kwargs["git_repo"]
    if kwargs["git_username"] != "" and kwargs["git_password"] != "":
        git_credens = "{}:{}".format(kwargs["git_username"], kwargs["git_password"])
        git_repo_with_credens = re.sub(
            r"(https://)(.*)", r"\1" + git_credens + "@" + r"\2", kwargs["git_repo"]
        )
    cmd = "git clone {} -b {} {}".format(
        git_repo_with_credens, kwargs["git_branch"], kwargs["repo_dir"]
    )
    ret = subprocess.call(cmd, shell=True)
    if ret:
        print("Failed to clone repo {}.".format(kwargs["git_repo"]))
        return False
    return True


def read_yaml(filename):
    """
    Reads the given config file and returns the contents of file in dict format
    """
    try:
        with open(filename, "r") as fh:
            return yaml.safe_load(fh)
    except OSError as error:
        return None


def execute_command(cmd, get_stderr=False):
    """
    Executes command in the local node
    """
    try:
        process = subprocess.run(
            cmd,
            shell=True,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,
        )
        output = process.stdout
        if get_stderr:
            err = process.stderr
            return output, err
        return output
    except Exception as e:
        log.info("Cluster created failed with error message: {}".format(e.stderr))
        if get_stderr:
            return None, None
        return None


def render_template(search_path, template_file, output_file, replace_vars):
    """Helper module to render jinja template"""

    try:
        templateLoader = jinja2.FileSystemLoader(searchpath=search_path)
        templateEnv = jinja2.Environment(loader=templateLoader)
        template = templateEnv.get_template(template_file)
        outputText = template.render(replace_vars)
        with open(output_file, "w") as fh:
            fh.write(outputText)
    except:
        print(
            "Failed to render template and create json " "file {}".format(output_file)
        )
        sys.exit(1)


def random_string():
    text = string.ascii_lowercase
    return "".join(random.choice(text) for i in range(5))


def get_provider_account_name(string_suffix: string = "DBAAS", invalid=None):
    isvname = string_suffix.lower().split(" ")[0]
    if invalid:
        return str(time.time())[-4:] + "-" + isvname + "-inv"
    else:
        return str(time.time())[-4:] + "-" + isvname + "-test"


def get_project_name(string_name: list):
    return str(time.time())[-4:] + "-" + ("-".join(string_name)).lower()


def get_instance_name(view: string):
    return view.lower() + "-inst-" + str(time.time())[-4:]
