# Ensure pip is installed
$pythonInstalled = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonInstalled) {
    Write-Error "Python is not installed or not added to PATH. Please install Python and make sure it's added to PATH."
    return
}

$pipInstalled = Get-Command pip -ErrorAction SilentlyContinue
if (-not $pipInstalled) {
    Write-Host "Installing pip..."
    Invoke-WebRequest "https://bootstrap.pypa.io/get-pip.py" -OutFile get-pip.py
    python get-pip.py
    Remove-Item get-pip.py
}

# Install robotframework and necessary libraries
Write-Host "Installing Robot Framework..."
pip install robotframework

Write-Host "Installing SeleniumLibrary for Robot Framework..."
pip install robotframework-seleniumlibrary

# Create project directory
New-Item -ItemType Directory -Path project\Keywords -Force
New-Item -ItemType Directory -Path project\Tests -Force
New-Item -ItemType Directory -Path project\Resources -Force

# Create __init__.robot files
New-Item -ItemType File -Path project\Keywords\__init__.robot -Force
New-Item -ItemType File -Path project\Tests\__init__.robot -Force
New-Item -ItemType File -Path project\Resources\__init__.robot -Force

# Create Keywords files
@"
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
"@ | Out-File -FilePath project\Keywords\e_commerce_keywords.robot

# Create Tests files
@"
*** Settings ***
Test Template  Run Keyword And Continue On Failure

*** Test Cases ***
Search and Add Product To Cart
    Open E-Commerce Website
    Search Product  Laptop
    Add Product To Cart
    Close Browser
"@ | Out-File -FilePath project\Tests\e_commerce_tests.robot

# Create Resources files
@"
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
"@ | Out-File -FilePath project\Resources\e_commerce_resources.robot

# Create API and DB folders and __init__.robot files
New-Item -ItemType Directory -Path project\Tests\API -Force
New-Item -ItemType Directory -Path project\Resources\API -Force
New-Item -ItemType Directory -Path project\Tests\DB -Force
New-Item -ItemType Directory -Path project\Resources\DB -Force

New-Item -ItemType File -Path project\Tests\API\__init__.robot -Force
New-Item -ItemType File -Path project\Resources\API\__init__.robot -Force
New-Item -ItemType File -Path project\Tests\DB\__init__.robot -Force
New-Item -ItemType File -Path project\Resources\DB\__init__.robot -Force

# Create API and DB test and resource files
@"
*** Settings ***
Test Template  Run Keyword And Continue On Failure

*** Test Cases ***
Test API Endpoint 1
    Log To Console  Testing API Endpoint 1

Test API Endpoint 2
    Log To Console  Testing API Endpoint 2
"@ | Out-File -FilePath project\Tests\API\api_tests.robot

@"
*** Variables ***
\${API_URL}  http://api.example.com

*** Keywords ***
Call API Endpoint 1
    Log To Console  Calling API Endpoint 1

Call API Endpoint 2
    Log To Console  Calling API Endpoint 2
"@ | Out-File -FilePath project\Resources\API\api_resources.robot

@"
*** Settings ***
Test Template  Run Keyword And Continue On Failure

*** Test Cases ***
Test Database Query 1
    Log To Console  Testing Database Query 1

Test Database Query 2
    Log To Console  Testing Database Query 2
"@ | Out-File -FilePath project\Tests\DB\db_tests.robot

@"
*** Variables ***
\${DB_HOST}  localhost
\${DB_USER}  root
\${DB_PASSWORD}  mypassword

*** Keywords ***
Execute Database Query 1
    Log To Console  Executing Database Query 1

Execute Database Query 2
    Log To Console  Executing Database Query 2
"@ | Out-File -FilePath project\Resources\DB\db_resources.robot
