Extensions
==========


Import a bunch of users (personas) int JumpCloud.

This script has an example CSV file which will import and activate users within JumpCloud. It alsoadds a default tag to every user.

Usage:

```
  JC_CSVUserImport.sh example-users.csv
```

Before you use this, replace `<CHANGE_TO_YOUR_JUMPCLOUD_API_KEY>` in this line:

```
  jumpCloudAPIKey="<CHANGE_TO_YOUR_JUMPCLOUD_API_KEY>"
```

Before you use this, replace `<CHANGE_TO_THE_DEFAULT_TAGS_YOU_WANT_TO_USE>` in this line:

```
  defaultTag="<CHANGE_TO_THE_DEFAULT_TAGS_YOU_WANT_TO_USE>"
```

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

Run the script on the command line on your OS X, or Linux system.
