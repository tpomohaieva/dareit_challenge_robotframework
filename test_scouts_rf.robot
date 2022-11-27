*** Settings ***
Library    SeleniumLibrary
Documentation    Suite description #automated tests for scout website

*** Variables ***
${LOGIN URL}                https://scouts-test.futbolkolektyw.pl/en
${BROWSER}                  Chrome
${LOGIN FORM}               xpath=//*[@id='__next']/form
${PASSWORD FIELD}           xpath=//*[@id='password']
${LOGIN FIELD}              xpath=//*[@id='login']
${INVALID DATA CAPTION}     xpath=//span[contains(@class, 'caption')]
${SIGN IN BUTTON}           xpath=//*[@type='submit']
${REMIND PASSWORD LINK}     xpath=//child::form//a
${SEND BUTTON}              xpath=//*[@type='submit']
${CHANGE LANGUAGE BUTTON}   xpath=//ul[2]//div[@role='button'][1]
${MAIN PAGE LINK}           xpath=//ul[1]//div[@role='button'][1]
${SIGN OUT BUTTON}          xpath=//ul[2]//div[@role='button'][2]
${LOGIN FORM TITLE}         xpath=//*[@id='__next']//h5
${MAIN PAGE LINK}           xpath=//ul[1]//div[@role='button'][1]
${ADD PLAYER BUTTON}            xpath=//a[contains(@href,'add')]
${SUBMIT BUTTON}                xpath=//button[@type='submit']
${PLAYER NAME FIELD}            xpath=//input[@name='name']
${PLAYER SURNAME FIELD}         xpath=//input[@name='surname']
${PLAYER AGE FIELD}             xpath=//input[@name='age']
${PLAYER MAIN POSITION FIELD}   xpath=//input[@name='mainPosition']
${FORM TITLE}                   xpath=//form//*[contains(@class, 'h5')]
${PROGRESS BAR TOASTER}         xpath=//*[@role='alert']
${REQUIRED DATA LABEL}          xpath=//p[contains(@class, 'required')]
${CLEAR BUTTON}                 xpath=//button[@type='submit']//following-sibling::button

*** Test Cases ***
Log in to the system with valid data
    Open login page
    Type in email
    Type in correct password
    Click on the Sign in button
    Assert dashboard
    [Teardown]    Close Browser

Log in to the system with invalid password
    Open login page
    Type in email
    Type in incorrect password
    Click on the Sign in button
    Assert password error
    [Teardown]    Close Browser

Log in to the system with missing login data
    Open login page
    Click on the Sign in button
    Assert login error
    [Teardown]    Close Browser

Check remind password functionality
    Open login page
    Click on the Remind password button
    Assert Remind password form
    [Teardown]    Close Browser

Log out of the system
    Open login page
    Type in email
    Type in correct password
    Click on the Sign in button
    Click on the Sign out button
    Assert Login page
    [Teardown]    Close Browser

Change language to Polish
    Open login page
    Type in email
    Type in correct password
    Click on the Sign in button
    Click on the Change language button
    Assert language change
    [Teardown]    Close Browser

Add player with valid data
    Open login page
    Type in email
    Type in correct password
    Click on the Sign in button
    Click on the Add player button
    Type in name
    Type in surname
    Type in age
    Type in main position
    Click on the Submit button
    Assert edit player page
    [Teardown]    Close Browser

Add player with missing required data
    Open login page
    Type in email
    Type in correct password
    Click on the Sign in button
    Click on the Add player button
    Click on the name field
    Click on the Submit button
    Assert required data error
    [Teardown]    Close Browser

Clear data on add player form
    Open login page
    Type in email
    Type in correct password
    Click on the Sign in button
    Click on the Add player button
    Type in name
    Type in surname
    Type in age
    Type in main position
    Click on the Clear button
    Assert empty fields
    [Teardown]    Close Browser

*** Keywords ***
Open login page
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Title Should Be    Scouts panel - sign in
Type in email
    Input Text    ${LOGIN FIELD}    user01@getnada.com
Type in correct password
    Input Text    ${PASSWORD FIELD}     Test-1234
Type in incorrect password
    Input Text    ${PASSWORD FIELD}     Test1234
Click on the Sign in button
    Click Element    ${SIGN IN BUTTON}
Assert dashboard
    Wait Until Element Is Visible    ${MAIN PAGE LINK}
    Title Should Be    Scouts panel
    Capture Page Screenshot    screenshots/login/dashboard-start.png
Assert password error
    Wait Until Element Is Visible    ${INVALID DATA CAPTION}
    Element Text Should Be      ${INVALID DATA CAPTION}     Identifier or password invalid.
    Capture Page Screenshot     screenshots/login/password-error.png
Assert login error
    Wait Until Element Is Visible    ${INVALID DATA CAPTION}
    Element Text Should Be      ${INVALID DATA CAPTION}     Please provide your username or your e-mail.
    Capture Page Screenshot     screenshots/login/email-error.png
Click on the Sign out button
    Wait Until Element Is Visible    ${SIGN OUT BUTTON}
    Click Element    ${SIGN OUT BUTTON}
Assert login page
    Wait Until Element Is Visible    ${LOGIN FORM}
    Title Should Be     Scouts panel - sign in
    Capture Page Screenshot    screenshots/login/login-page.png
Click on the Remind password button
    Click Element       ${REMIND PASSWORD LINK}
Assert Remind password form
    Wait Until Element Is Visible    ${SEND BUTTON}
    Title Should Be     Remind password
    Capture Page Screenshot    screenshots/login/remind-pw.png
Click on the Change language button
    Wait Until Element Is Visible    ${MAIN PAGE LINK}
    Click Element    ${CHANGE LANGUAGE BUTTON}
Assert language change
    Element Text Should Be      ${CHANGE LANGUAGE BUTTON}     English
    Capture Page Screenshot     screenshots/dashboard/language-set-pl.png
Click on the Add player button
    Wait Until Element Is Visible       ${MAIN PAGE LINK}
    Click Element    ${ADD PLAYER BUTTON}
Type in name
    Wait Until Element Is Visible       ${FORM TITLE}
    Input Text      ${PLAYER NAME FIELD}    Test
Type in surname
    Input Text      ${PLAYER SURNAME FIELD}     Testowski
Type in age
    Input Text      ${PLAYER AGE FIELD}     01/01/1990
Type in main position
    Input Text      ${PLAYER MAIN POSITION FIELD}       Forward
Click on the Submit button
    Click Element    ${SUBMIT BUTTON}
Assert edit player page
    Wait Until Element Is Visible    ${PROGRESS BAR TOASTER}
    Element Should Contain      ${FORM TITLE}   Edit player
    Capture Page Screenshot    screenshots/add-player/player-added.png
Click on the name field
    Wait Until Element Is Visible    ${FORM TITLE}
    Click Element    ${PLAYER NAME FIELD}
Assert required data error
    Wait Until Element Is Visible    ${REQUIRED DATA LABEL}
    Element Text Should Be    ${REQUIRED DATA LABEL}    Required
    Capture Page Screenshot    screenshots/add-player/required-player-data.png
Click on the Clear button
    Click Element    ${CLEAR BUTTON}
Assert empty fields
    Element Text Should Be    ${PLAYER NAME FIELD}    ${EMPTY}
    Element Text Should Be    ${PLAYER SURNAME FIELD}    ${EMPTY}
    Element Text Should Be    ${PLAYER AGE FIELD}    ${EMPTY}
    Element Text Should Be    ${PLAYER MAIN POSITION FIELD}    ${EMPTY}
    Capture Page Screenshot    screenshots/add-player/fields-cleared.png