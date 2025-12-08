# How to run this project task:

- Make sure you have the NodeJs library, minimum version required by application is 18.
- Clone the repository to your local machine.
- Check `.env` file in the root folder of the project and make sure that the `REACT_APP_BASE_API_URL` and `REACT_APP_ENABLE_LOCAL_API` variable is set to the correct values:
  - if you run the backend locally, then the `REACT_APP_BASE_API_URL` value should be `http://127.0.0.1:3000` and `REACT_APP_ENABLE_LOCAL_API = true`
  - if you run the backend on the server, then ask DevOps team for correct value of `REACT_APP_BASE_API_URL` and change `REACT_APP_ENABLE_LOCAL_API = false`
  - Note: Webpack can't change environment variables from `.env` file on the 'fly', so you need to restart the application after changing the value of any variable in the `.env` file.
- Dependencies are installed from the console with the `npm install` command (or `npm i`), you can see dependencies in the package.json file in the `dependencies` and `devDependencies` keys,
- Dev version of the application is started with the command `npm run start` (can be shortened to `npm start`).
- To run unit test cases open another terminal and enter the command "npm run test" or "npm test" and you can watch the results in terminal itself.
- To watch the coverage of unit test cases of the application, open another terminal and enter the command "npm run test:coverage" and you can watch the coverage table in the terminal itself.

### Notice:

- sometimes for correct operation, npm commands must be run from the My-Music-App folder level, since the repository is initialized in the "frontend-music-app" folder, and the application itself is located in the "My-Music-App" folder.
- we periodically add new libraries to the project, so if you have any problems with the launch, please start the command "npm install" again.
- while backed is runnig locally, you maybe need to update their part as well
- for backend compatibility the application starts on port 3001 using the cross-env library, if you have problems with this start method use the standard one which is saved with the postfix :stndb the start command in this case looks like `npm run start:stnd`

### Front-End Testing End Points:

- `/` : the Home Page.
- `/sign-in` : Sign in page.
- `/sign-up` : Sign up page.
- `/my-playlists` : "My playlists" page (Note: Auth reqiured)
- `/my-playlists/details/{playlist_id}` : Details of one selected (clicked) "My" playlist
- `/public-playlists` : "Public playlists" page
- `/public-playlists/details/{playlist_id}` : Details of one selected (clicked) "Public" playlist

# Music Application Business Goal

    - Collaborative Playlist Sharing
    - Platform-Free Playlist Creation
    - Public Playlists Creation

### Application Overview:

    1. Create and share playlists with their friends
       - Playlists -> Private, Public, Shared
    2. Songs, Users can add and manage songs with playlists.
       - Users-> Guest, Authenticated, Admin.

### Application Screens and Features:

    1 [x] Sign in
    2 [x] Sign up
    3 [x] Home:
        - It should contain Playlists(Most popular, Featured, Last added)
        - Songs(Most popular, Last added, Top 10)
        - Users and contributors(Created most playlist, Have most friends)
    4 [x] Playlist:
    5. Public Playlists:
        - Top public playlists ordered by like and date
        - playlist detail page with songs
        - Filter & Sort playlists
    6. Shared Playlists:
        - Users can see Shared Playlists of my friends
        - Add songs to Shared Playlists
    7. My Playlists:
        - Create new playlist
        - Modify playlist name, logo, description
        - Delete a playlist
        - Add songs to playlist
        - Change playlist type
        - Write a comment
    8. My Account:
        - Account Management
        - Modify the nickname, profile picture
        - Delete the account
        - Sign out
    9. Friends:
        - List of Friends
        - Received Friend Request
        - Submitted Friends Request
        - Friends Management

### Notification Management:

##### Music App includes a comprehensive notification and email system that will send automatic emails of the following types:

    - Friends Requests
    - Admin notifications
    - Playlist Milestones

### Project Priorities:

    1. Playlists (Public, Shared, Private)
    2. Songs (Adding songs to playlist)
    3. Friends, Account (Adding friends and sharing playlists)
    4. Notification Management (Emails to authenticated users)
