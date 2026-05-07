#!/usr/bin/env python3
"""
Path checking tools for ensuring files and folders meet permission and ownership expectations
"""

import argparse
import grp
import logging
import os
import pwd
import sys
import yaml


# set initial error state
ERRORS = False


def check_mismatch_perms(path, status, perms):
    """
    Takes a path string, an os.path object and a string of unix perms (eg. 755)
    returns T/F depending on whether or not there's a mismatch between the two.
    """
    logging.info("Checking path permissions...")
    if str(oct(status.st_mode)[-3:]) == perms:
        logging.info("Permissions OK")
    else:
        logging.error("Incorrect permissions on %s", path)
        return True
    return False


def check_mismatch_user(path, status, user):
    """
    Takes a path string, an os.stat(path) object and a username string.
    Returns T/F depending on whether or not there's a mismatch between the two
    """
    logging.info("Checking user...")
    required_uid = pwd.getpwnam(user).pw_uid
    if status.st_uid == required_uid:
        logging.info("User OK")
    else:
        logging.error("Incorrect user on %s", path)
        return True
    return False


def check_mismatch_group(path, status, group):
    """
    Takes a path string, an os.stat(path) object and a group name string.
    Returns T/F depending on whether or not there's a mismatch between the two
    """
    logging.info("Checking group...")
    required_gid = grp.getgrnam(group).gr_gid
    if status.st_gid == required_gid:
        logging.info("Group OK")
    else:
        logging.error("Incorrect group on %s", path)
        return True
    return False


def check_mismatch_type(path, ptype):
    """
    Checks the supplied path against the supplied ptype (path type)
    ptype can be one of link, dir, file
    """
    logging.info("Checking path type...")
    if ptype == "link":
        is_type = os.path.islink(path)
    elif ptype == "dir":
        is_type = os.path.isdir(path)
    elif ptype == "file":
        is_type = os.path.isfile(path)
    else:
        logging.error("Incorrect type specified in yaml")
        is_type = False

    if is_type:
        logging.info("Type OK")
    else:
        logging.error("Incorrect type on %s", path)
        return True
    return False


def path_checks(path, config):
    """
    Performs the defined checks against the supplied path
    """
    errors = []
    if os.path.exists(path):
        logging.info("Path exists: %s", path)
        status = os.stat(path)

        errors.append(check_mismatch_perms(path, status, str(config["perms"])))

        errors.append(check_mismatch_user(path, status, config["user"]))

        errors.append(check_mismatch_group(path, status, config["group"]))

        errors.append(check_mismatch_type(path, config["type"]))

    else:
        logging.error("file not found: %s", path)
        errors.append(True)

    return errors


def main():
    """
    main
    """
    PARSER = argparse.ArgumentParser(
        prog="path_check",
        description="Validates file paths according to a documented spec",
        epilog="",
    )
    PARSER.add_argument(
        "-p", "--path", help="path to config file", default="path-checks.yaml"
    )
    PARSER.add_argument(
        "-q", "--quiet", help="display minimal output", action="store_true"
    )

    ARGV = PARSER.parse_args()

    if ARGV.quiet:
        logging.basicConfig(
            format="%(asctime)s [%(levelname)s] %(message)s", level=logging.ERROR
        )
    else:
        logging.basicConfig(
            format="%(asctime)s [%(levelname)s] %(message)s", level=logging.INFO
        )

    logging.info("Starting checks...")
    global_errors = []
    with open(ARGV.path, "r", encoding="utf8") as file:
        paths = yaml.safe_load(file)

    for path, config in paths.items():
        global_errors.extend(path_checks(path, config))

    if True in global_errors:
        logging.error("Errors encountered. Please review and try again")
        sys.exit(1)


if __name__ == "__main__":
    main()
