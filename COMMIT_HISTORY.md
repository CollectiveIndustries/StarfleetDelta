* 9ed92de Update ISSUE_TEMPLATE.md
* 5bca388 Create ISSUE_TEMPLATE.md
* ff900e1 Adds channel tags for switching inputs.
* 6a876d7 Updates changelog
* ec68687 Reformatts all php code with astyle.
* 08d9e82 Adds db comms, Closes #31
* ae377e4 Fixes formatting using astyle
*   985bcf7 Merge branch 'master' of github.com:CollectiveIndustries/StarfleetDelta
|\  
| * e0fb99f Update sid_cpu.lsl
* | 19aabf5 Adds the Desk display system
|/  
* 09acdfd SID CPU script by Kodos
* ec8486d Adds a stats display for Time clock users.
* 3ba5e71 Reformatts Timeclock.lsl
* 163e1e9 Reformats names, Removes account information.
* e364df9 Manually cleaned up remaining names from PHP code
* 7737ceb Fixes extra file in repo
* 446e19b Minor changes
* 771555f More Reformatting
* ad83dfa Reformatts SQL with new name
* 5858298 Reformatts SQL with new name
* fe04db0 Updates python config file
* a9a3e25 Reformats files for Starfleet Delta
* aeca5e8 Fixes CSS names
* d236baf Renames files
* e4c2349 Updates changelog
* f5cde13 Updates all code for Starfleet Delta
* c787fbf Updates Readme to reflect name change on project code.
* de32888 Updates changelog
* f095c4b Reformats LSL code with astyle
*   b638768 Merge branch 'master' of github.com:CollectiveIndustries/UFGQ
|\  
| * d39448a Update statuslight.lsl
| * b6932d0 Create statuslight.lsl
| * 4c94601 Create soundemitter.lsl
| * b48c733 Create lightemitter.lsl
* | a16a232 Adds IFNULL() to Titler display name for a fallback, also Fixes #9.
|/  
* 0601e96 Fixes #35, System will now pause after a configurable 3 second touch.
* 001d067 Updates changelog
* 623a235 Reformats the HTTP Error, also adds a menu button to open the github issue tracker on the main page. Fixes #36
* 8a6716b Adds llRegionSay() to nanorc, Fixes variables
* 823a48a Reformatts LSL with astyle formatting.
* 438d585 Adds .orig file to the ignore list so we can format using astyle
* 9c0db11 Reformatts code with astyle
* ae8d84b Fixes ERROR:: (191, 19): 'MEMU_TIMEOUT' is undeclared.
* 25370c1 Updates changelog
* 43eb9b1 Fixes #37, Adds in Timer Events for menu timeouts, and variable cleanup.
* 84fe071 Rename lsl/Acedemy/viewscreen.lsl to lsl/Acedemy/viewscreen/viewscreen.lsl
* c038677 Create viewscreen.lsl
* 7b7cd68 Updates changelog
* dedf130 Finishes #32, the HTTP scripts now handle ASSETS with types, as well as display text reformatting and secured password based channels.
* bd7923b Create server-framework.lsl
* db40246 Update messages.lsl
* 07d53b8 Fixes ERROR:: ( 19, 46): Expression and constant without operator.
* 5418570 Reformats spaces to tabs at the begining of the lines.
* 4c9947c Adds a message manipluation function for Kodos
* 5547276 Updates changelog
* 7cf2ebd Adds in a basic HTTP Course reader for the database. Fixes #32
* feea03d Updates changelog
* e7b000f Fixes #30, SQL Statements now correctly add a user with all requyired information to the database
* e62ed62 Adds asset system and authentication codes to the database, also updates functions and adds a staff list
* b3658bf Updates changelog
*   8f144b3 Merge branch 'master' of github.com:CollectiveIndustries/UFGQ
|\  
| * 2943321 Update titler.lsl
| * 420e6d5 Updates changelog
| * 27242e0 Updates changelog
| * 4ee8ef0 Updates changelog
| * ef854a6 Updates changelog
| * a4ef3ba Updates changelog
| * e9cc472 Updates changelog
| * 01c7513 Fixes #23, Creating a new administrator durring install no longer shows password
| * 1cac3ba Fixes #26, also adds a useable error message for failed connections
* | 66546f5 Sets up UFGQ Email address on registration
|/  
* 000d85e Adds a few support scripts to webpage
* 8162120 Login script is working correctly but not redirecting to welcome page.
* b52cc13 Updates changelog
* 380f3be Fixes #22 this is only a temporary fix untill a solution is found
* ac5206e Updates DB Install SQL with Gradebook, Divisions, Titles, Ranks, and Courses
* 8e5489a Updates changelog
* 03b28c6 Updates changelog
* d55206e Fixes #24, rebuild configuration settings to there proper values.
* a35bd83 Updates changelog to reflect current state
* 3700c75 closes #20, Statistics are now displayed as a Floating text and linked to the stats.php page
* c213586 Adds CSS theme to the Rank Marks page.
* f8d48dd Adds Rank marks page and Stats interface.
* 5bc5b8c Updates changelog to reflect current state
* 54d5312 fixes #18, sets up utf-8 connection to database.
* 6988935 LSL Script now parses webpage corectly giving color and proper tags. UTF-8 Encoding is still broken.
* 7494d5d Fixes POST variable
* bbf5049 Fixes syntax and whitespace, tags are working UTF-8 is still coming through as '?'
* fa205e7 Adds chatbot.lsl for the Welcome center
* de1c2e0 Preliminary updates for UTF-8
* 4f2750a Adds data for support tables, updates all the table structures for new account system
* b6069cc Updates Changelog
* 2950e68 Fixes Civilian tags. Closes #16
* 0f12701 Adds DB Titler
* 1acb7bc Updates Readme
* 5e3619e Updates DB Installer with the latest version
*   0f11be8 Merges Installer Changes
|\  
| * 8162406 Adds comments to titler
| * 52b426d Updates changelog
| * a84843b fixes #17, removes a - in the comment section that messed everything up.
* | 74af9b1 Removes old Titler scripts
|/  
* daf34df Adds titler base scripts to project
* e44b8c5 Readds a few lins after the merge
* ea5d56d Changelog updates
*   ca31e7b Fixes #15, fixes Database connection settings, Fixes error return codes, Fixes new time clock user.
|\  
| * 5beeb36 Updates bugs in changelog
| * d41a203 Fixes #14 this adds the correct Mysql database structure that the PHP scripts are trying to use
| * 02be30c Reformats issue titles for changelog readability.
| * 67b54f4 Updates changelog
| * 58c187b Variable optimization, and error handling tweaks
| * 38e8e32 Adds comment blocks to each functions, sets up variables in the User config section
| *   b8a0889 Merge branch 'master' of https://github.com/CollectiveIndustries/UFGQ
| |\  
| * | 82bf37e Seperates mysql port number from host in php configuration settings.
| * | a572dd8 Fixes swp ignore
| * | 0bd69ed Removes publicly visable chat
* | | 37fc2a5 Updates to add Usernames to DB, and changes Error messages
| |/  
|/|   
* | 6456623 Adds Database sanity checks for new UFGQ Personell
* | 14ace71 Adds random sounds for Time clock
* | 627c600 Updates changelog to reflect bug fixes
* | 69f2900 Fixes #12, IM now works correctly
* | 637ffcc updates CHANGELOG.md
* | b510ef8 Time clock now Clocks user in but not out
* | 467fd62 Fixes Name not defined within scope
* |   d999bf1 Merge pull request #11 from MyNameIsKodos/patch-1
|\ \  
| * | 7c75f1d Update timeclock.lsl
|/ /  
* | 7b37a5b Resets  the Logo back to the Comms Logo
* | bbdb178 Manualy resolves timeclock merge conflict
* | a4a581d Manualy resolved merge conflict
* |   a252461 Resolves merge conflicts
|\ \  
| |/  
| * e04f068 Adds syntax highlighters and fixes readability on timeclock. Various tweaks.
| * 84f5131 Updates Commit History.
| * bf3d983 Fixes installer.py merge conflict
* | 0dc7cb6 Fixes LSL script and adds Install.py back to repo
|/  
* 7f60075 Adds HTTP Request for Profile Picture. Adds IM for user.
* 75ecfaa fixes Missaligned Brackets
* 0dfcbee Variable fixes
* d98e5d2 Syntax Error fixes
* f89a261 Adds profile screen
* 531b3e7 Tab optimization
* 49d2e45 Variable optimization
* a1baf0e Clock textures
* dff3eb5 variable rewrites
* 87ce0e9 Initial clock commit
* bbc77f4 Adds Service record forms to repository
* 7083ad1 Adds commit history
* 34713c4 updates changelog
* e88bc75 Adds github-changelog-generator style changelog
* 14a6990 Fixes Commit tags in changelog
* c6fc03f Adds a changelog
* bdb2a60 rebuilds SQL statment and fixes SLQ Injection bug.
* da5d7fb adds debug info to Error message
* 8c20e57 adds login redirecter
* 948e61d It is a good practice to call exit() right after header() so that code below it does not get executed when redirecting.
* 395162d fixes SQL statements. Adds return code to MySQL Error
* fb3746e fixes #4 login box for vertically centered alignment
* 64ffd72 Adds file installer for the webpage.
* 9e0d53b Ignores php Config file. This file is now dynamicly generated from the Python installer and might contain sesitive information
* af44b04 Adds php configuration settings from installer
* 8f3a749 Changes fonts + boarder colors
* 7f29fb0 Adds comments
* fd707cb Adds theme to login page
* 7d95e8f removes extra comments and sleep()
* 237fe9b Fixes #2, Fixes issue #3
* d090af7 Still broken
* b97299f Adds fields for config.php and section for WEB config.
* 3e4df21 Adds PHP Config builder, Small text changes on login page
* 8352b5f Sets up first web user account on commandline and impliments sha512 password hashing
* c0cfcba Adds php/mysql login page example code
* 9cc090b removes duplicate import statement
* 6bc777e Adds a TODO List and fixes comments
* 7e968b4 Readability tweaks.
* 3e00ca9 Fixes issue #1
* bf78664 Adds swp to ignore list
* efd6393 Finishes MySQL file installer
* db53fd1 Spelling updates
* 2e34f83 Adds file section to config
* 2e388ae Tweaks and changes for installing an SQL file directly to a database
* 12be06c removes ignores files
* a0978b4 Fixes python gitignore
* 8dc5e23 Adds python gitignore
* e1df332 Adds configuration files and support scripts for installing a MySQL Database
* bb47173 reorginization of the file system structure
* b9aa6bd Layout for wiki page
* deff74d OpenComputer LUA script
* 3977d47 Syncronized server clock with google
* 9d312e8 Updates for the system profiles
* 5462c31 Adds preliminary Databse Install files
* 49566ab Initial commit
