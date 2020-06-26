## Crypto-Inspector
This is an iOS app which allows users to monitor current price of crypto-coins.
  - Using coinapi to fetch all crypto-coins
  - To use, create a Secrets.plist with project, create dictionary and use apikey for coinapi
  ```
  Secrets.plist:
    apikey: XXXXX XXXX XXX
  ```

### Configuration Page
<div style="display: flex;" align="center">
  <img src="https://github.com/vishnudivakar31/Crypto-Inspector/blob/master/Crypto%20Inspector/Screenshots/Configuration.jpeg" width="200" height="400" />
  <img src="https://github.com/vishnudivakar31/Crypto-Inspector/blob/master/Crypto%20Inspector/Screenshots/Configuration-Search.jpeg" width="200" height="400" />
  <img src="https://github.com/vishnudivakar31/Crypto-Inspector/blob/master/Crypto%20Inspector/Screenshots/Configuration-MultiSelect.jpeg" width="200" height="400" />
</div>

When user first installs the app and launch, the user would be asked to select the coins to follow.
  - First image shows the default configuration page
  - Second image shows the search functionality where user can search particular coins
  - Third image shows the multi-select functionality

### Home Page
<div style="display: flex;" align="center">
  <img src="https://github.com/vishnudivakar31/Crypto-Inspector/blob/master/Crypto%20Inspector/Screenshots/Home-Default.jpeg" width="200" height="400" />
  <img src="https://github.com/vishnudivakar31/Crypto-Inspector/blob/master/Crypto%20Inspector/Screenshots/home-edit.gif" width="200" height="400" />
  <img src="https://github.com/vishnudivakar31/Crypto-Inspector/blob/master/Crypto%20Inspector/Screenshots/delete-coin.jpeg" width="200" height="400" />
</div>

User can view all the followed coins and prices are updated every one minute.
  - By default coin prices will be monitored as per local currency
  - Users can edit the coin to change currency
  - Users can delete coin to stop following the coin price

### Edit Page
<div style="display: flex;" align="center">
  <img src="https://github.com/vishnudivakar31/Crypto-Inspector/blob/master/Crypto%20Inspector/Screenshots/editpage.jpeg" width="200" height="400" />
  <img src="https://github.com/vishnudivakar31/Crypto-Inspector/blob/master/Crypto%20Inspector/Screenshots/Edit-Search.jpeg" width="200" height="400" />
</div>

User can edit currency for each coin to monitor.
  - User can search for a particular currency to attach with the coin.
