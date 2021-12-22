*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser    ${RAFFLE_WEBSITE}    browser=${BROWSER}
Suite Teardown    Close All Browsers

*** Variables ***
${RAFFLE_WEBSITE}    https://www.wheelofnames.com
${RAFFLE_NAVBAR}    //div[@class='navbar-brand']

${COOKIE_BANNER_IFRAME}    ifrmCookieBanner
${REJECT_COOKIES_BUTTON}    //button[@aria-label='DISAGREE']

${LIST_OF_NAMES}    entries
${FIRST_NAME_ON_LIST}    (//div[@id='${LIST_OF_NAMES}']/div)[1]
${SHUFFLE_BUTTON}    //i[@class='fas fa-random']/ancestor::button
${RAFFLE_WHEEL_INSTRUCTION}    bottomInstruction
${RAFFLE_WHEEL}    wheelCanvas

${WINNER_BANNER}    //div[@class='modal-card']
${REMOVE_NAME_BUTTON}    //button[@class='button is-medium is-info']
${REMOVED_NAME_TITLE}    //h1

${BROWSER}    gc
${LONG_TIMEOUT}    20 s
@{PARTICIPANTS}    Person1    Person2    Person3
...    Person4
*** Test Cases ***
Spin The Wheel
    Open Raffle Website
    Input And Shuffle Participants    ${PARTICIPANTS}
    Start Raffle
    Remove Names And Spin Until Winner Is Found    ${PARTICIPANTS}
    Display The Winner
    Sleep    10 s

*** Keywords ***
Open Raffle Website
    Wait Until Page Contains Element    ${RAFFLE_NAVBAR}
    Wait Until Page Contains Element    ${REJECT_COOKIES_BUTTON}    ${LONG_TIMEOUT}
    Maximize Browser Window
    Click Button    ${REJECT_COOKIES_BUTTON}

Input And Shuffle Participants
    [Arguments]    ${list_of_participants}
    Wait Until Page Contains Element    ${LIST_OF_NAMES}
    Clear Element Text    ${LIST_OF_NAMES}
    ${names}=    Catenate    SEPARATOR=\n    @{list_of_participants}
    Input Text    ${LIST_OF_NAMES}    ${names}
    Click Button    ${SHUFFLE_BUTTON}

Start Raffle
    Wait Until Page Contains Element    ${RAFFLE_WHEEL_INSTRUCTION}
    Log To Console    Let the raffle begin!
    Click Element    ${RAFFLE_WHEEL_INSTRUCTION}
    Press Keys    None    CONTROL+ENTER

Remove Names And Spin Until Winner Is Found
    [Arguments]    ${list_of_participants}
    ${amount_of_participants}=    Get Length    ${list_of_participants}
    ${iterations}=    Evaluate    ${amount_of_participants} - 2
    FOR    ${iteration}    IN RANGE    ${iterations}
        Round Number Of Participants Remaining    ${iteration}    ${iterations}
		Remove Name And Spin The Wheel
    END

Remove Name And Spin The Wheel
    ${eliminated_player}=    Remove Name From Raffle
    Log To Console    ${eliminated_player} was eliminated from the raffle
    Click Element    ${RAFFLE_WHEEL}
	
Round Number Of Participants Remaining
	[Arguments]    ${iteration_number}    ${total}
	${remaining}=    Evaluate    ${total}-${iteration_number}+2
	${round}=    Evaluate    ${remaining}%10==0
	Run Keyword If    ${round}    Log To Console    ${remaining} players remaining!

Display The Winner
    ${last_eliminated_player}=    Remove Name From Raffle
    Log To Console    ${last_eliminated_player} was the last person to be eliminated
    ${winner}=    Get Element Attribute    ${FIRST_NAME_ON_LIST}    outerText
    Log To Console    ${winner} wins the raffle. Congratulations!

Remove Name From Raffle
    Wait Until Page Contains Element    ${WINNER_BANNER}    ${LONG_TIMEOUT}
    Wait Until Page Contains Element    ${REMOVE_NAME_BUTTON}
    ${removed_name}=    Get Element Attribute    ${REMOVED_NAME_TITLE}    outerText
    Click Button    ${REMOVE_NAME_BUTTON}
    Wait Until Element Is Visible    ${RAFFLE_WHEEL}
    [Return]    ${removed_name}



