#!/usr/bin/env python3
import grp
import logging
import os
import pwd
import stat
import sys
import yaml

logging.basicConfig(format='%(asctime)s [%(levelname)s] %(message)s',
        level=logging.INFO)

# set initial error state
ERRORS=False

def path_checks(path, config):
    global ERRORS
    if os.path.exists(path):
        logging.info(f"file found: {path}")
        status = os.stat(path)
        # print(status)

        logging.info("Checking path permissions...")
        if str(oct(status.st_mode)[-3:]) == str(config["perms"]):
            logging.info("Permissions OK")
        else:
            logging.error(f"Incorrect permissions on {path}")
            ERRORS=True


        logging.info("Checking user...")
        required_uid = pwd.getpwnam(config["user"]).pw_uid
        if status.st_uid == required_uid:
            logging.info("User OK")
        else:
            logging.error(f"Incorrect user on {path}")
            ERRORS=True

        logging.info("Checking group...")
        required_gid = grp.getgrnam(config["group"]).gr_gid
        if status.st_gid == required_gid:
            logging.info("Group OK")
        else:
            logging.error(f"Incorrect group on {path}")
            ERRORS=True

        logging.info("Checking type...")
        if config["type"] == "link":
            IS_TYPE = os.path.islink(path)
        elif config["type"] == "dir":
            IS_TYPE = os.path.isdir(path)
        elif config["type"] == "file":
            IS_TYPE = os.path.isfile(path)
        else:
            logging.error(f"Incorrect type specified in yaml")
            IS_TYPE=False
            ERRORS=True

        if IS_TYPE:
            logging.info("Type OK")
        else:
            logging.error(f"Incorrect type on {path}")
            ERRORS=True

    else:
        logging.error(f"file not found: {path}")
        ERRORS=True


def main():
    logging.info("Starting up...")


    with open("path-checks.yaml", "r", encoding="utf8") as file:
        paths = yaml.safe_load(file)

    for path, config in paths.items():
        path_checks(path, config)



    if ERRORS:
        logging.error("Errors encountered. Please review and try again")
        sys.exit(1)



if __name__ == "__main__":
    main()
