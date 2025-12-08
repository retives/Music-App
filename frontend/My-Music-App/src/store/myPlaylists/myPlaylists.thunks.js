import { createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';
import { FETCH_PLAYLISTS_TYPES, MY_PLAYLISTS_URL } from '../constants';

// Fetch page of ten My Playlist Data Thunk
export const fetchPageOfMyPlaylists = createAsyncThunk(
  'myPlaylistsSlice/fetchPageOfMyPlaylists',
  async (page = 1, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      const response = await axios({
        url: MY_PLAYLISTS_URL,
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
        params: {
          playlist_type: FETCH_PLAYLISTS_TYPES.MY,
          page,
        },
      });
      return response.data;
    } catch (error) {
      throw error.response.data.errors;
    }
  }
);
export const fetchPageOfMyPlaylistsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchPageOfMyPlaylistsFulfilled = (state, action) => {
  state.loading = false;
  state.myPlaylists = action.payload.playlists.data;
  state.metadata = action.payload.metadata;
};
export const fetchPageOfMyPlaylistsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

// Delete My Playlist Thunk
export const deleteMyPlaylist = createAsyncThunk(
  'myPlaylistsSlice/deleteMyPlaylist',
  async (playlistId, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      const response = await axios({
        url: `${MY_PLAYLISTS_URL}/${playlistId}`,
        method: 'DELETE',
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
      });
      return { data: response.data, playlistId };
    } catch (error) {
      throw error.response.data.errors;
    }
  }
);
export const deleteMyPlaylistPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const deleteMyPlaylistFulfilled = (state, action) => {
  state.loading = false;
  state.shouldRefreshMyPlaylists = true;
};
export const deleteMyPlaylistRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

// Add My Playlist Thunk
export const addMyPlaylist = createAsyncThunk(
  'myPlaylistsSlice/addMyPlaylist',
  async (formData, { getState }) => {
    const accessToken = getState().user.accessToken;
    const { page } = getState().myPlaylistsSlice.metadata;
    try {
      await axios({
        url: `${MY_PLAYLISTS_URL}`,
        method: 'POST',
        data: formData,
        headers: {
          Accept: '*/*',
          'Content-Type': 'multipart/form-data',
          Authorization: `Bearer ${accessToken}`,
        },
      });
      // secon async operation
      const response = await axios({
        url: MY_PLAYLISTS_URL,
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
        params: {
          playlist_type: FETCH_PLAYLISTS_TYPES.MY,
          page,
        },
      });
      return response.data;
    } catch (error) {
      throw error.message;
    }
  }
);
export const addMyPlaylistPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const addMyPlaylistFulfilled = (state, action) => {
  state.loading = false;
  state.myPlaylists = action.payload.playlists.data;
  state.metadata = action.payload.metadata;
};
export const addMyPlaylistRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

// Edit My Playlist Thunk
export const editMyPlaylist = createAsyncThunk(
  'myPlaylistsSlice/editMyPlaylist',
  async (data, { getState }) => {
    const accessToken = getState().user.accessToken;
    let { playlistId, formData } = data;
    try {
      const response = await axios({
        url: `${MY_PLAYLISTS_URL}/${playlistId}`,
        method: 'PUT',
        data: formData,
        headers: {
          Accept: '*/*',
          'Content-Type': 'multipart/form-data',
          Authorization: `Bearer ${accessToken}`,
        },
      });

      const index = getState().myPlaylistsSlice.myPlaylists.findIndex(
        (playlist) => playlist.id === playlistId
      );
      let playlist = getState().myPlaylistsSlice.myPlaylists[index];
      const { name, description, logo } = response.data.data.attributes;
      playlist = {
        ...playlist,
        attributes: {
          ...playlist.attributes,
          name,
          description,
          logo,
        },
      };
      return { data: playlist, playlistId };
    } catch (error) {
      throw error.response.data.errors;
    }
  }
);
export const editMyPlaylistPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const editMyPlaylistFulfilled = (state, action) => {
  state.loading = false;

  let payload = action.payload.data;
  if (!payload.attributes.first_ten_songs) {
    payload = {
      ...action.payload.data,
      attributes: {
        ...action.payload.data.attributes,
        first_ten_songs: { data: [] },
      },
    };
  }

  const index = state.myPlaylists.findIndex(
    (playlist) => playlist.id === action.payload.playlistId
  );
  state.myPlaylists.splice(index, 1, payload);
};
export const editMyPlaylistRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};
