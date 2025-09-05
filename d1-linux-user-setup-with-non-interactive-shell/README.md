useradd -> Linux utility to create a new user account
-s /sbin/nologin -> specifies login shell for the new user
    /sbin/nologin -> special shell that immediately exits and shows a message like "This account is currently not available". this prevent the user (rose) from logging into the server interactively (via ssh, terminal, etc).
/etc/passwd -> the system file that stores basic info about all user accounts.
