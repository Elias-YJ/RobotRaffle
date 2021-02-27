# RobotRaffle

This repository contains a program for your weekly raffle needs. To avoid accusations of rigging the raffle, this program automates the steps needed to run a raffle using a third party website called [Wheel of Names](www.wheelofnames.com).

![wheel of names](https://wheelofnames.com/images/fb-screenshot.png)

## Running the program

The program is written using Robot Framework, which is an open sourced automation framework.
Below are some tips and tricks to get started with using Robot Framework.

![robot framwework logo](https://pbs.twimg.com/profile_images/932695487932784640/QdWJdB_g_200x200.jpg)



### Official guides and instructions
- [Detailed installation instructions](https://github.com/robotframework/robotframework/blob/master/INSTALL.rst)
- [Quick start guide](https://github.com/robotframework/QuickStartGuide/blob/master/QuickStart.rst)

### My recommended installation steps (overview)
1. Prepare a python environment, for example by using `venv` package or Anaconda
2. Install Robot Framework and SeleniumLibrary
  ```
  pip install robotframework
  pip install robotframework-seleniumlibrary
  ```
3. Download the latest [chromeDriver](https://chromedriver.chromium.org/) and add its location to the environment variable `PATH`
4. Run the program using the following command
  ```
  robot raffle.robot
  ```
  You can add optional arguments to switch browsers or redirect output files:
  ```
  robot -d reports -v BROWSER:firefox raffle.robot
  ```
