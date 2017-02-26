
#README

Each class/exam pair will need to be seperated into the sdq_classes and the sdq_exams directories accordingly. The installer programs will break if these directories are not kept seprate.

### Classes Formattting
Title of File: class name, number, and author in the format ABC-123_FIRTNAME_LASNAME.txt

First Line of file: ```<DESC:Description of Class>```

All other text for the file on its own line.

If you would like to add a sound or texture to the class to be used durring presentation it will need its own tag as follows.

SOUND tag: ```<SOUND:UUID>```

TEXTURE tag: ```<TEXTURE:UUID>```

Other keywords and tags you may use are:

```<LIGHTS_OFF>``` - This will dim all the lights attached to the classroom and display ```*RANK FIRSTNAME LASTNAME dims the lights*``` in Local chat.

```<LIGHTS_ON>``` - This tag will cause the Exams system to start pulling information from the database and will turn all the lights back on. Once the "reader" script hits the end of the file it will pass out the exams to each desk and allow the user to interact with the desk displays.

### Exams Format

```
1. Question
A:Answer A
B:Answer B
C:Answer C
D:Correct Answer D
D
```
Every question on the exam will need to be formatted using this template as the python scripts will crash with extra characters and out of place questions.
