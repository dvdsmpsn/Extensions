#!/bin/bash

#########################################################################################
#
# JC_CSVUserImport.sh - imports users from a CSV file into JumpCloud(tm)
#
# This script accepts a .csv file as an argument, in the following forms:
#
# username,password,email,firstname,lastname
#
# and loads them as system users into JumpCloud. As is normal for JumpCloud, any newly-added
# users will receive an email prompting them to set up their password, SSH public
# key, and Google Authenticator.
#
# If you have any questions or problems with the operation of this script, please
# contact support@jumpcloud.com.
#
# License: This script is made available by JumpCloud under the
#   Mozilla Public License v2.0 (https://www.mozilla.org/MPL/2.0/)
#
# Author: James D. Brown (james@jumpcloud.com)
# Created: Fri, Apr 11, 2014
#
# Updated: David Simpson (david@davidsimpson.me) / March 2015
#
# Copyright (c) 2014 JumpCloud, Inc.
#
#########################################################################################

######
# -------------------------- START USER CUSTOMIZATION SECTION  --------------------------
######

#
# To obtain your API key, login to the JumpCloud console, and using your user account
# menu in the upper right corner of the screen, select "API Settings".
#
jumpCloudAPIKey="<CHANGE_TO_YOUR_JUMPCLOUD_API_KEY>"

defaultTag="<CHANGE_TO_THE_DEFAULT_TAGS_YOU_WANT_TO_USE"

######
# --------------------------- END USER CUSTOMIZATION SECTION  ---------------------------
######

sourceFiles="${*}"

if [ "$#" -lt 1 ]
then
    echo "Usage: $0 <file1> [[<file2>] ... ]"
    exit 1
fi

APIKeyIsValid() {
    login="${1}"

    result=`curl --silent \
        -d "{\"filter\": [{\"username\" : \"${login}\"}]}" \
        -X 'GET' \
        -H 'Content-Type: application/json' \
        -H 'Accept: application/json' \
        -H "x-api-key: ${jumpCloudAPIKey}" \
        "https://console.jumpcloud.com/api/systemusers"`

    if [ "${result}" = "Unauthorized" ]
    then
        return 1
    fi

    return 0
}

findAccountInJumpCloud() {
    login="${1}"

    curl --silent \
        -d "{\"filter\": [{\"username\" : \"${login}\"}]}" \
        -X 'POST' \
        -H 'Content-Type: application/json' \
        -H 'Accept: application/json' \
        -H "x-api-key: ${jumpCloudAPIKey}" \
        "https://console.jumpcloud.com/api/search/systemusers"
}

addAccountToJumpCloud() {
    login="${1}"
	password="${2}"
    email="${3}"
	firstname="${4}"
	lastname="${5}"

    result=`curl --silent \
        -d "{  \
			   \"username\"  : \"${login}\",      \
			   \"password\"  : \"${password}\",      \
			   \"email\"     : \"${email}\",         \
			   \"firstname\" : \"${firstname}\",     \
			   \"lastname\"  : \"${lastname}\",      \
			   \"tags\"      : [ \"${defaultTag}\" ] \
		    }" \
        -X 'POST' \
        -H 'Content-Type: application/json' \
        -H 'Accept: application/json' \
        -H "x-api-key: ${jumpCloudAPIKey}" \
        "https://console.jumpcloud.com/api/systemusers"`

    if [ `echo "${result}" | grep -c '"status"'` -eq 1 ]
    then
        echo "${result}"
    fi
}

normalizeCSV() {
    files="${*}"

    cat ${files} | tr "\r" "\n" | gawk -F',' '{
        login="";
		password="";
        email="";
		firstname="";
		lastname="";

        # Is this a heading line?
        if (NR == 1 && NF == 2 && $2 !~ /@/) {

            # Yep, looks like a header, skip it
            next;
        }

        # Remove any double-quotes
        gsub(/"/, "");

		login=$1;
		password=$2;
		email=$3;
		firstname=$4;
		lastname=$5;

        printf("%s,%s,%s,%s,%s\n", login, password, email, firstname, lastname);
    }' -
}

APIKeyIsValid

if [ ${?} -eq 1 ]
then
    echo "ERROR: The API key is unauthorized."
    exit 1
fi

for file in ${sourceFiles}
do
    if [ ! -r "${file}" ]
    then
        echo "${file}: does not exist"

        continue;
    fi

    normalizeCSV "${file}" | while read line
    do
        login=`echo ${line}  | awk -F',' '{ print $1; }' -`
        password=`echo ${line}  | awk -F',' '{ print $2; }' -`
        email=`echo ${line}     | awk -F',' '{ print $3; }' -`
        firstname=`echo ${line} | awk -F',' '{ print $4; }' -`
        lastname=`echo ${line}  | awk -F',' '{ print $5; }' -`

        #
        # Account already in JumpCloud?
        #
        if [ `findAccountInJumpCloud "${login}" | grep -c "\"totalCount\":1"` -eq 1 ]
        then
            echo "${login}: already exists in JumpCloud"
        else
            echo -n "Adding ${firstname} ${lastname} / ${login} (${email}) : "

            #
            # Nope, add it
            #
            result=`addAccountToJumpCloud "${login}" "${password}" "${email}" "${firstname}" "${lastname}"`

            if [ ! -z "${result}" ]
            then
                echo "ERROR: ${result}"
            else
                echo "SUCCESS"
            fi
        fi
    done
done

exit 0
