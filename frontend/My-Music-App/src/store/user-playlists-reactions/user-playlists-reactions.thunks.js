import { createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';
import { API_URL, ERROR_RESPONSE_CODES } from '../constants';

export const fetchPlaylistsReactions = createAsyncThunk(
  'user/fetchPlaylistsReactions',
  async (_, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      const response = await axios({
        url: `${API_URL}/my/reactions`,
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
        transformResponse: [
          (responseData) => {
            const {
              reactions: { data },
            } = JSON.parse(responseData);
            return data;
          },
          (data) =>
            data.map(({ attributes: { playlist_id, status } }) => {
              return {
                playlistId: playlist_id.toString(),
                isLiked: status === 1,
                isDisliked: status === 0,
              };
            }),
        ],
      });
      return {
        playlistsReactions: response.data,
      };
    } catch (error) {
      if (error.response.status === ERROR_RESPONSE_CODES.UNAUTHORIZED)
        throw new Error('401 Unauthorized');

      throw error.response.data.errors;
    }
  }
);

export const fetchPlaylistsReactionsPending = (state) => {
  state.loading = true;
  state.error = null;
};

export const fetchPlaylistsReactionsFulfilled = (state, action) => {
  state.loading = false;
  state.playlistsReactions = action.payload.playlistsReactions;
};

export const fetchPlaylistsReactionsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};
