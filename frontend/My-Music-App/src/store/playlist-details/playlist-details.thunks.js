import { createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';
import {
  ERROR_RESPONSE_CODES,
  ERROR_RESPONSE_MESSAGES,
  FETCH_PLAYLISTS_TYPES,
  MY_PLAYLISTS_URL,
  PUBLIC_PLAYLIST_URL,
  PUBLIC_PLAYLIST_URL as PLAYLIST_REACTION_URL,
} from '../constants';
import {
  capitalizeWords,
  formatDateDDmmmYYYY,
  parseLikesDislikes,
} from '../helpers';

export const fetchPlaylistDetails = createAsyncThunk(
  'playlistDetailsSlice/fetchPlaylistDetails',
  async ({ playlistId, playlistTypeToDisplay }, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      if (playlistTypeToDisplay === FETCH_PLAYLISTS_TYPES.MY) {
        const response = await axios({
          url: `${PUBLIC_PLAYLIST_URL}/${playlistId}`,
          headers: {
            Accept: '*/*',
            Authorization: `Bearer ${accessToken}`,
          },
        });
        return response.data;
      }
      if (playlistTypeToDisplay === FETCH_PLAYLISTS_TYPES.PUBLIC) {
        const response = await axios({
          url: `${PUBLIC_PLAYLIST_URL}/${playlistId}`,
          headers: {
            Accept: '*/*',
          },
        });
        return response.data;
      }
      if (playlistTypeToDisplay === FETCH_PLAYLISTS_TYPES.SHARED) {
        const response = await axios({
          url: `${PUBLIC_PLAYLIST_URL}/${playlistId}`,
          headers: {
            Accept: '*/*',
            Authorization: `Bearer ${accessToken}`,
          },
        });
        return response.data;
      }
      throw new Error('Unknown playlist type');
    } catch (error) {
      throw error.response.data.errors;
    }
  }
);
export const fetchPlaylistDetailsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchPlaylistDetailsFulfilled = (state, action) => {
  state.loading = false;
  const {
    data: {
      id: playlistId,
      attributes: {
        created_on: createdOnZ,
        updated_on: updatedOnZ,
        name: playlistName,
        playlist_type: playlistType,
        logo,
        description,
        number_likes_dislikes: numberLikesDislikes,
      },
    },
    included,
  } = action.payload;
  const { likes, dislikes } = parseLikesDislikes(numberLikesDislikes);
  const songs = included.filter((item) => item.type === 'song');
  const ownerInfo = included.filter((item) => item.type === 'user')[0];
  state.playlistDetails.playlistInfo = {
    playlistId,
    createdOn: formatDateDDmmmYYYY(createdOnZ),
    updatedOn: formatDateDDmmmYYYY(updatedOnZ),
    playlistName,
    playlistType,
    logo,
    description,
    likes,
    dislikes,
  };
  state.playlistDetails.ownerInfo = {
    email: ownerInfo.attributes.email,
    registerDate: formatDateDDmmmYYYY(ownerInfo.attributes.register_date),
    playlistsOwned: ownerInfo.attributes.playlists_number,
  };
  state.playlistDetails.songs = songs;
};
export const fetchPlaylistDetailsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

/**
 * @desc Changing playlist type alowed only for authorized users
 * @param {string} newPlaylistType - new playlist type from const PLAYLIST_PRIVACY_TYPES
 */
export const changePlaylistType = createAsyncThunk(
  'playlistDetailsSlice/changePlaylistType',
  async (newPlaylistType, { getState }) => {
    const accessToken = getState().user.accessToken;
    const playlistId =
      getState().playlistDetailsSlice.playlistDetails.playlistInfo.playlistId;
    try {
      const response = await axios({
        url: `${MY_PLAYLISTS_URL}/${playlistId}/playlist_type?playlist_type=${newPlaylistType}`,
        method: 'PUT',
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
      });
      return {
        newPlaylistType: response.data.data.attributes.playlist_type,
      };
    } catch (error) {
      if (error.response.status === ERROR_RESPONSE_CODES.UNPROCESSABLE_ENTITY)
        throw new Error(ERROR_RESPONSE_MESSAGES.UNPROCESSABLE_ENTITY);

      throw error.response.data.errors;
    }
  }
);
export const changePlaylistTypePending = (state) => {
  state.loading = true;
  state.error = null;
};
export const changePlaylistTypeFulfilled = (state, action) => {
  state.loading = false;
  state.playlistDetails.playlistInfo.playlistType =
    action.payload.newPlaylistType;
};
export const changePlaylistTypeRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

// Delete Song From Playlist Thunk
export const deleteSongFromPlaylist = createAsyncThunk(
  'playlistDetailsSlice/deleteSongFromPlaylist',
  async (idSongToDelete, { getState }) => {
    const accessToken = getState().user.accessToken;
    const playlistId =
      getState().playlistDetailsSlice.playlistDetails.playlistInfo.playlistId;
    try {
      const response = await axios({
        url: `${MY_PLAYLISTS_URL}/${playlistId}/playlist_songs/${idSongToDelete}`,
        method: 'DELETE',
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
      });
      return { data: response.data, idSongToDelete };
    } catch (error) {
      throw error.response.data.errors;
    }
  }
);
export const deleteSongFromPlaylistPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const deleteSongFromPlaylistFulfilled = (state, action) => {
  state.loading = false;
  state.playlistDetails.songs = state.playlistDetails.songs.filter(
    //If all OK, no need to refetch fetchPlaylistDetails, just delete same song from state
    (song) => song.id !== action.payload.idSongToDelete
  );
};
export const deleteSongFromPlaylistRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

// Add Song To Playlist Thunk
export const addSongToPlaylist = createAsyncThunk(
  'playlistDetailsSlice/addSongToPlaylist',
  async (params, { getState }) => {
    const { playlist_id, song_id, song } = params;
    const accessToken = getState().user.accessToken;
    try {
      await axios({
        url: `${MY_PLAYLISTS_URL}/${playlist_id}/playlist_songs`,
        params: { playlist_id, song_id },
        method: 'POST',
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
      });
      const nickname = getState().user.credentials.nickname;
      const updatedSong = {
        ...song,
        attributes: { ...song.attributes, added_by: nickname },
      };
      return updatedSong;
    } catch (error) {
      throw error.message;
    }
  }
);
export const addSongToPlaylistPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const addSongToPlaylistFulfilled = (state, action) => {
  state.loading = false;
  state.playlistDetails.songs = [
    ...state.playlistDetails.songs,
    action.payload,
  ];
};
export const addSongToPlaylistRejected = (state, action) => {
  state.loading = false;
  state.error = action.error;
};

// Edit PlaylistDetail Thunk

export const editPlaylistDetails = createAsyncThunk(
  'playlistDetailsSlice/editPlaylistDetails',
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
      return response.data.data.attributes;
    } catch (error) {
      throw error.response.data.errors;
    }
  }
);
export const editPlaylistDetailsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const editPlaylistDetailsFulfilled = (state, action) => {
  state.loading = false;
  const { logo, description, name } = action.payload;
  state.playlistDetails.playlistInfo = {
    ...state.playlistDetails.playlistInfo,
    playlistName: name,
    logo,
    description,
  };
};
export const editPlaylistDetailsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const fetchPlaylistComments = createAsyncThunk(
  'playlistDetailsSlice/fetchPlaylistComments',
  async ({ playlistId, playlistTypeToDisplay, page = 1 }, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      if (playlistTypeToDisplay === FETCH_PLAYLISTS_TYPES.PUBLIC) {
        const response = await axios({
          url: `${PUBLIC_PLAYLIST_URL}/${playlistId}/comments?page=${page}`,
          headers: {
            Accept: '*/*',
          },
        });
        return response.data;
      }
      if (playlistTypeToDisplay !== FETCH_PLAYLISTS_TYPES.PUBLIC) {
        const response = await axios({
          url: `${PUBLIC_PLAYLIST_URL}/${playlistId}/comments?page=${page}`,
          headers: {
            Accept: '*/*',
            Authorization: `Bearer ${accessToken}`,
          },
        });
        return response.data;
      }
    } catch (error) {
      if (error.response.status === ERROR_RESPONSE_CODES.NOT_FOUND)
        throw new Error(ERROR_RESPONSE_MESSAGES.NOT_FOUND);
      if (error.response.status === ERROR_RESPONSE_CODES.UNAUTHORIZED)
        throw new Error(ERROR_RESPONSE_MESSAGES.UNAUTHORIZED);

      throw error.response.data.errors;
    }
  }
);
export const fetchPlaylistCommentsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchPlaylistCommentsFulfilled = (state, action) => {
  state.loading = false;
  const {
    comments: { data },
    metadata,
  } = action.payload;

  state.playlistDetails.commentsInfo.comments = data.map(
    ({
      id,
      attributes: { user_name, user_email, user_picture, created_at, content },
    }) => ({
      id: id,
      userName: capitalizeWords(user_name),
      userEmail: user_email,
      userPicture: user_picture,
      createdAtZ: created_at,
      content: content,
    })
  );
  state.playlistDetails.commentsInfo.metadata = {
    commentsCount: metadata.count,
    lastPage: metadata.last,
  };
};
export const fetchPlaylistCommentsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const addCommentToPlaylist = createAsyncThunk(
  'playlistDetailsSlice/addCommentToPlaylist',
  async (commentContent, { getState }) => {
    const accessToken = getState().user.accessToken;
    const playlistId =
      getState().playlistDetailsSlice.playlistDetails.playlistInfo.playlistId;
    try {
      const response = await axios({
        url: `${PUBLIC_PLAYLIST_URL}/${playlistId}/comments`,
        method: 'POST',
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
        data: {
          content: commentContent,
        },
      });
      return response.data;
    } catch (error) {
      if (error.response.status === ERROR_RESPONSE_CODES.UNAUTHORIZED)
        throw new Error(ERROR_RESPONSE_MESSAGES.UNAUTHORIZED);
      if (error.response.status === ERROR_RESPONSE_CODES.UNPROCESSABLE_ENTITY) {
        const errMsgArr = error?.response?.data?.errors?.details?.base;
        if (errMsgArr !== undefined && Array.isArray(errMsgArr)) {
          throw errMsgArr.join(', ');
        }
      }
      throw error;
    }
  }
);

export const addCommentToPlaylistPending = (state) => {
  state.loading = true;
  state.error = null;
};

export const addCommentToPlaylistFulfilled = (state, action) => {
  const {
    data: {
      id,
      attributes: { user_name, user_email, user_picture, created_at, content },
    },
  } = action.payload;
  const newComment = {
    id,
    userName: capitalizeWords(user_name),
    userEmail: user_email,
    userPicture: user_picture,
    createdAtZ: formatDateDDmmmYYYY(created_at),
    content,
  };

  state.loading = false;
  state.playlistDetails.commentsInfo.comments = [
    newComment,
    ...state.playlistDetails.commentsInfo.comments,
  ];
  state.playlistDetails.commentsInfo.metadata.commentsCount =
    state.playlistDetails.commentsInfo.metadata.commentsCount + 1;
};

export const addCommentToPlaylistRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const fetchPlaylistReaction = createAsyncThunk(
  'playlistDetailsSlice/fetchPlaylistReaction',
  async (playlistId, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      const response = await axios({
        url: `${PLAYLIST_REACTION_URL}/${playlistId}/reaction`,
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
        transformResponse: [
          (responseData) => {
            const { reaction } = JSON.parse(responseData);
            return {
              isLiked: reaction.data?.attributes.status === 1,
              isDisliked: reaction.data?.attributes.status === 0,
            };
          },
        ],
      });
      return response.data;
    } catch (error) {
      if (error.response.status === ERROR_RESPONSE_CODES.UNAUTHORIZED)
        throw new Error(ERROR_RESPONSE_MESSAGES.UNAUTHORIZED);
      if (error.response.status === ERROR_RESPONSE_CODES.NOT_FOUND)
        throw new Error(ERROR_RESPONSE_MESSAGES.NOT_FOUND);

      throw error.response.data.errors;
    }
  }
);

export const fetchPlaylistReactionPending = (state) => {
  state.loading = true;
  state.error = null;
};

export const fetchPlaylistReactionFulfilled = (state, action) => {
  state.loading = false;
  state.playlistDetails.playlistReaction = action.payload;
};

export const fetchPlaylistReactionRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const postPlaylistLike = createAsyncThunk(
  'playlistDetailsSlice/postPlaylistLike',
  async (playlistId, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      await axios({
        url: `${PLAYLIST_REACTION_URL}/${playlistId}/reaction`,
        method: 'POST',
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
        data: {
          status: 1,
        },
      });
      return {
        isLiked: true,
        isDisliked: false,
      };
    } catch (error) {
      if (error.response.status === ERROR_RESPONSE_CODES.UNAUTHORIZED)
        throw new Error(ERROR_RESPONSE_MESSAGES.UNAUTHORIZED);
      if (error.response.status === ERROR_RESPONSE_CODES.UNPROCESSABLE_ENTITY)
        throw new Error(ERROR_RESPONSE_MESSAGES.UNPROCESSABLE_ENTITY);

      throw error.response.data.errors;
    }
  }
);
export const postPlaylistLikePending = (state) => {
  state.loading = true;
  state.error = null;
};
export const postPlaylistLikeFulfilled = (state, action) => {
  state.loading = false;
  state.playlistDetails.playlistReaction.isLiked = action.payload.isLiked;
  state.playlistDetails.playlistReaction.isDisliked = action.payload.isDisliked;
};
export const postPlaylistLikeRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const postPlaylistDislike = createAsyncThunk(
  'playlistDetailsSlice/postPlaylistDislike',
  async (playlistId, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      await axios({
        url: `${PLAYLIST_REACTION_URL}/${playlistId}/reaction`,
        method: 'POST',
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
        data: {
          status: 0,
        },
      });
      return {
        isLiked: false,
        isDisliked: true,
      };
    } catch (error) {
      if (error.response.status === ERROR_RESPONSE_CODES.UNAUTHORIZED)
        throw new Error(ERROR_RESPONSE_MESSAGES.UNAUTHORIZED);
      if (error.response.status === ERROR_RESPONSE_CODES.UNPROCESSABLE_ENTITY)
        throw new Error(ERROR_RESPONSE_MESSAGES.UNPROCESSABLE_ENTITY);

      throw error.response.data.errors;
    }
  }
);
export const postPlaylistDislikePending = (state) => {
  state.loading = true;
  state.error = null;
};
export const postPlaylistDislikeFulfilled = (state, action) => {
  state.loading = false;
  state.playlistDetails.playlistReaction.isLiked = action.payload.isLiked;
  state.playlistDetails.playlistReaction.isDisliked = action.payload.isDisliked;
};
export const postPlaylistDislikeRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const deletePlaylistReaction = createAsyncThunk(
  'playlistDetailsSlice/deletePlaylistReaction',
  async (playlistId, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      await axios({
        url: `${PLAYLIST_REACTION_URL}/${playlistId}/reaction`,
        method: 'DELETE',
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
      });
      return {
        isLiked: false,
        isDisliked: false,
      };
    } catch (error) {
      if (error.response.status === ERROR_RESPONSE_CODES.UNAUTHORIZED)
        throw new Error(ERROR_RESPONSE_MESSAGES.UNAUTHORIZED);
      if (error.response.status === ERROR_RESPONSE_CODES.NOT_FOUND)
        throw new Error(ERROR_RESPONSE_MESSAGES.NOT_FOUND);

      throw error.response.data.errors;
    }
  }
);

export const deletePlaylistReactionPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const deletePlaylistReactionFulfilled = (state, action) => {
  state.loading = false;
  state.playlistDetails.playlistReaction.isLiked = action.payload.isLiked;
  state.playlistDetails.playlistReaction.isDisliked = action.payload.isDisliked;
};
export const deletePlaylistReactionRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};
