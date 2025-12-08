import { combineReducers } from '@reduxjs/toolkit';
import { userReducer } from './user/user.reducer';
import { myPlaylistsReducer } from './myPlaylists/myPlaylists.reducer';
import { publicPlaylistsReducer } from './public-playlists/public-playlists.reducer';
import { homePageReducer } from './homePage/homePage.reducer';
import { sharedPlaylistsReducer } from './shared-playlists/shared-playlists.reducer';
import { playlistDetailsReducer } from './playlist-details/playlist-details.reducer';
import { addSongsModalReducer } from './addSongsModal/addSongsModal.reducer';
import { userPlaylistsReactionsReducer } from './user-playlists-reactions/user-playlists-reactions.reducer';
import { myAccountReducer } from './my-account/my-account.reducer';
import { friendsReducer } from './friends/friends.reducer';
import { aboutPageReducer } from './aboutPage/aboutPage.reducer';
import { appReducer } from './app/app.reducer';

export const rootReducer = combineReducers({
  user: userReducer,
  myPlaylistsSlice: myPlaylistsReducer,
  publicPlaylistsSlice: publicPlaylistsReducer,
  sharedPlaylistsSlice: sharedPlaylistsReducer,
  homePageSlice: homePageReducer,
  playlistDetailsSlice: playlistDetailsReducer,
  addSongsModalSlice: addSongsModalReducer,
  userPlaylistsReactionsSlice: userPlaylistsReactionsReducer,
  myAccountSlice: myAccountReducer,
  friendsSlice: friendsReducer,
  aboutPageSlice: aboutPageReducer,
  appSlice: appReducer,
});
