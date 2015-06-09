# Extensions

## Introduction

Import a bunch of users (personas) into [JumpCloud](http://jumpcloud.com/).

This script has an example CSV file which will import and activate users within JumpCloud. It also adds a default tag to every user.

Adding the password seems to activate the users. Replace this field with something else for security reasons.

Usage:

```
  JC_CSVUserImport.sh example-users.csv
```

## Before you begin

Replace `<CHANGE_TO_YOUR_JUMPCLOUD_API_KEY>` in this line:

```
  jumpCloudAPIKey="<CHANGE_TO_YOUR_JUMPCLOUD_API_KEY>"
```

Replace `<CHANGE_TO_THE_DEFAULT_TAGS_YOU_WANT_TO_USE>` in this line:

```
  defaultTag="<CHANGE_TO_THE_DEFAULT_TAGS_YOU_WANT_TO_USE>"
```

## CSV format

The script supports CSV files in the following format:

```
  username,password,email,firstname,surname
```

e.g.

```
  a9b6f,jumpcloud,eros.turpis@quisaccumsan.ca,Dacey,Lester
  a4e2b,jumpcloud,egestas.urna@pedeetrisus.co.uk,Aretha,Henry
  aff89,jumpcloud,vestibulum.Mauris@neque.ca,Yoshi,Ball
```

## And finally...

Run the script on the command line on your OS X, or Linux system.
