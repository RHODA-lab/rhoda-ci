# -*- coding: utf-8 -*-
try:
    from setuptools import find_packages, setup
except ImportError:
    from ez_setup import use_setuptools

    use_setuptools()
    from setuptools import find_packages, setup

setup(
    name="rhoda-ci",
    version="0.1",
    description="Red Hat OpenShift Database Access Operator QE Tier Tests",
    author="rhoda-ci",
    author_email="rhoda-ci@redhat.com",
    install_requires=[
        "reportportal-client",
        "robotframework>=4",
        "robotframework-debuglibrary",
        "robotframework-requests",
        "robotframework-seleniumlibrary",
        "robotframework-jupyterlibrary>=0.3.1",
        "robotframework-OpenShiftCLI==1.0.1",
        "ipython",
        "pytest",
        "pytest-logger",
        "pyyaml",
        "pygments",
        "requests",
        "robotframework-requests",
        "escapism",
        "semver>=2,<3",
    ],
    zip_safe=True,
    include_package_data=True,
    packages=find_packages(exclude=["ez_setup"]),
)
