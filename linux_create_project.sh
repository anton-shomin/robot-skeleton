#!/bin/bash

# Check if python3 is installed
if ! command -v python3 &> /dev/null
then
    echo "Python3 is not installed. Please install Python3 and try again."
    exit 1
fi

# Check if pip3 is installed
if ! command -v pip3 &> /dev/null
then
    echo "pip3 is not installed. Installing pip3..."
    sudo apt update
    sudo apt install -y python3-pip
fi

# Install robotframework and necessary libraries
echo "Installing Robot Framework..."
pip3 install robotframework

echo "Installing SeleniumLibrary for Robot Framework..."
pip3 install robotframework-seleniumlibrary


# Create project directory
mkdir -p project/Keywords project/Tests project/Resources

# Create __init__.robot files
touch project/Keywords/__init__.robot project/Tests/__init__.robot project/Resources/__init__.robot

# Create Keywords files
cat <<EOL > project/Keywords/e_commerce_keywords.robot
*** Settings ***
Library  SeleniumLibrary

*** Keywords ***
Open E-Commerce Website
    Open Browser  http://www.example.com  chrome

Close Browser
    Close Browser

Search Product
    [Arguments]  \${product}
    Input Text  css=input[name='search']  \${product}
    Click Element  css=input[type='submit']

Add Product To Cart
    Click Element  css=button.add-to-cart
EOL

# Create Tests files
cat <<EOL > project/Tests/e_commerce_tests.robot
*** Settings ***
Test Template  Run Keyword And Continue On Failure

*** Test Cases ***
Search and Add Product To Cart
    Open E-Commerce Website
    Search Product  Laptop
    Add Product To Cart
    Close Browser
EOL

# Create Resources files
cat <<EOL > project/Resources/e_commerce_resources.robot
*** Variables ***
\${URL}  http://www.example.com

*** Keywords ***
Open E-Commerce Website
    Open Browser  \${URL}  chrome

Close Browser
    Close Browser

Search Product
    [Arguments]  \${product}
    Input Text  css=input[name='search']  \${product}
    Click Element  css=input[type='submit']

Add Product To Cart
    Click Element  css=button.add-to-cart
EOL

# Create API and DB folders and __init__.robot files
mkdir -p project/Tests/API project/Resources/API project/Tests/DB project/Resources/DB

touch project/Tests/API/__init__.robot project/Resources/API/__init__.robot project/Tests/DB/__init__.robot project/Resources/DB/__init__.robot

# Create API and DB test and resource files
cat <<EOL > project/Tests/API/api_tests.robot
*** Settings ***
Test Template  Run Keyword And Continue On Failure

*** Test Cases ***
Test API Endpoint 1
    Log To Console  Testing API Endpoint 1

Test API Endpoint 2
    Log To Console  Testing API Endpoint 2
EOL

cat <<EOL > project/Resources/API/api_resources.robot
*** Variables ***
\${API_URL}  http://api.example.com

*** Keywords ***
Call API Endpoint 1
    Log To Console  Calling API Endpoint 1

Call API Endpoint 2
    Log To Console  Calling API Endpoint 2
EOL

cat <<EOL > project/Tests/DB/db_tests.robot
*** Settings ***
Test Template  Run Keyword And Continue On Failure

*** Test Cases ***
Test Database Query 1
    Log To Console  Testing Database Query 1

Test Database Query 2
    Log To Console  Testing Database Query 2
EOL

cat <<EOL > project/Resources/DB/db_resources.robot
*** Variables ***
\${DB_HOST}  localhost
\${DB_USER}  root
\${DB_PASSWORD}  mypassword

*** Keywords ***
Execute Database Query 1
    Log To Console  Executing Database Query 1

Execute Database Query 2
    Log To Console  Executing Database Query 2
EOL
