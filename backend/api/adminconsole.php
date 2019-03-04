<?php
include_once '../api.php';

$URL = 'adminconsole.php';

$api = new API();

if (!$api->isloggedin) {
    print "Log in to continue";
    print "<form action='${URL}?login' method='post'>";
    print "username: <input type='text' name='username'>";
    print "password: <input type='password' name='password'>";
    print "<input type='submit' value='login'>";
    print "</form>";
}

if($api->isloggedin) {
    print "{$api->username} logged in | ";
    print "<a href='$URL?logout'>log out</a>";
    print "<form method='post' action='$URL?logout'>\n";
    print "<button type='submit'>Logout</button>\n";
    print "</form>\n";
    print "<form method='post' action='${URL}?user&account'>\n";
    print "<button type='submit'>Account</button>\n";
    print "</form>\n";
}

?>