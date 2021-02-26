*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser    ${RAFFLE_WEBSITE}    browser=gc
Suite Teardown    Close All Browsers

*** Variables ***
${RAFFLE_WEBSITE}    https://www.wheelofnames.com
${RAFFLE_NAVBAR}    //div[@class='navbar-brand']

${COOKIE_BANNER_IFRAME}    ifrmCookieBanner
${REJECT_COOKIES_BUTTON}    //button[@class='sp-close-button']

${LIST_OF_NAMES}    names
${SHUFFLE_BUTTON}    //i[@class='fas fa-random']/ancestor::button
${RAFFLE_WHEEL_INSTRUCTION}    bottomInstruction
${RAFFLE_WHEEL}    wheelCanvas

${WINNER_BANNER}    //div[@class='modal-card']
${REMOVE_NAME_BUTTON}    //button[@class='button is-medium is-info']

${LONG_TIMEOUT}    20 s
@{PARTICIPANTS}    Person1    Person2    Person3
...    Person4
*** Test Cases ***
LaLa Raffle
    Open Raffle Website
    Input And Shuffle Participants    ${PARTICIPANTS}
    Start Raffle
    Remove Name And Spin The Wheel
    Sleep    10 s


*** Keywords ***
Open Raffle Website
    Maximize Browser Window
    Wait Until Page Contains Element    ${RAFFLE_NAVBAR}
    Wait Until Page Contains Element    ${COOKIE_BANNER_IFRAME}    ${LONG_TIMEOUT}
    Select Frame    ${COOKIE_BANNER_IFRAME}
    Click Button    ${REJECT_COOKIES_BUTTON}
    Unselect Frame

Input And Shuffle Participants
    [Arguments]    ${list_of_participants}
    Wait Until Page Contains Element    ${LIST_OF_NAMES}
    Clear Element Text    ${LIST_OF_NAMES}
    ${names}=    Catenate    SEPARATOR=\n    @{list_of_participants}
    Input Text    ${LIST_OF_NAMES}    ${names}
    Click Button    ${SHUFFLE_BUTTON}

Start Raffle
    Wait Until Page Contains Element    ${RAFFLE_WHEEL_INSTRUCTION}
    Click Element    ${RAFFLE_WHEEL_INSTRUCTION}
    Press Keys    None    CONTROL+ENTER

Remove Name And Spin The Wheel
    Wait Until Page Contains Element    ${WINNER_BANNER}    ${LONG_TIMEOUT}
    Wait Until Page Contains Element    ${REMOVE_NAME_BUTTON}
    ${removed_name}=    Get Element Attribute    //h1    outerText
    Log To Console    ${removed_name} was eliminated from the raffle
    Click Button    ${REMOVE_NAME_BUTTON}
    Wait Until Element Is Visible    ${RAFFLE_WHEEL}
    Click Element    ${RAFFLE_WHEEL}


