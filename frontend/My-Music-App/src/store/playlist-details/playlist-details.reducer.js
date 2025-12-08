import { createSlice } from '@reduxjs/toolkit';
import * as thunks from './playlist-details.thunks';

const initialState = {
  loading: false,
  error: null,
  playlistDetails: {
    playlistInfo: {
      playlistId: null,
      createdOn: null,
      updatedOn: null,
      playlistName: null,
      playlistType: null,
      logo: null,
      description: null,
      likes: null,
      dislikes: null,
    },
    ownerInfo: {
      email: null,
      registerdate: null,
      playlistsOwned: null,
    },
    playlistReaction: {
      isLiked: null,
      isDisliked: null,
    },
    songs: [],
    commentsInfo: {
      comments: [],
      metadata: { commentsCount: 0 },
    },
  },
};

export const playlistDetailsSlice = createSlice({
  name: 'playlistDetailsSlice',
  initialState: initialState,
  reducers: {
    setCurrentPlaylist: (state, action) => {
      state.playlistDetails = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(
        thunks.fetchPlaylistDetails.pending,
        thunks.fetchPlaylistDetailsPending
      )
      .addCase(
        thunks.fetchPlaylistDetails.fulfilled,
        thunks.fetchPlaylistDetailsFulfilled
      )
      .addCase(
        thunks.fetchPlaylistDetails.rejected,
        thunks.fetchPlaylistDetailsRejected
      )
      .addCase(
        thunks.changePlaylistType.pending,
        thunks.changePlaylistTypePending
      )
      .addCase(
        thunks.changePlaylistType.fulfilled,
        thunks.changePlaylistTypeFulfilled
      )
      .addCase(
        thunks.changePlaylistType.rejected,
        thunks.changePlaylistTypeRejected
      )
      .addCase(
        thunks.deleteSongFromPlaylist.pending,
        thunks.deleteSongFromPlaylistPending
      )
      .addCase(
        thunks.deleteSongFromPlaylist.fulfilled,
        thunks.deleteSongFromPlaylistFulfilled
      )
      .addCase(
        thunks.deleteSongFromPlaylist.rejected,
        thunks.deleteSongFromPlaylistRejected
      )
      .addCase(
        thunks.addSongToPlaylist.pending,
        thunks.addSongToPlaylistPending
      )
      .addCase(
        thunks.addSongToPlaylist.fulfilled,
        thunks.addSongToPlaylistFulfilled
      )
      .addCase(
        thunks.addSongToPlaylist.rejected,
        thunks.addSongToPlaylistRejected
      )
      .addCase(
        thunks.editPlaylistDetails.pending,
        thunks.editPlaylistDetailsPending
      )
      .addCase(
        thunks.editPlaylistDetails.fulfilled,
        thunks.editPlaylistDetailsFulfilled
      )
      .addCase(
        thunks.editPlaylistDetails.rejected,
        thunks.editPlaylistDetailsRejected
      )
      .addCase(
        thunks.fetchPlaylistComments.pending,
        thunks.fetchPlaylistCommentsPending
      )
      .addCase(
        thunks.fetchPlaylistComments.fulfilled,
        thunks.fetchPlaylistCommentsFulfilled
      )
      .addCase(
        thunks.fetchPlaylistComments.rejected,
        thunks.fetchPlaylistCommentsRejected
      )
      .addCase(
        thunks.addCommentToPlaylist.pending,
        thunks.addCommentToPlaylistPending
      )
      .addCase(
        thunks.addCommentToPlaylist.fulfilled,
        thunks.addCommentToPlaylistFulfilled
      )
      .addCase(
        thunks.addCommentToPlaylist.rejected,
        thunks.addCommentToPlaylistRejected
      )
      .addCase(
        thunks.fetchPlaylistReaction.pending,
        thunks.fetchPlaylistReactionPending
      )
      .addCase(
        thunks.fetchPlaylistReaction.fulfilled,
        thunks.fetchPlaylistReactionFulfilled
      )
      .addCase(
        thunks.fetchPlaylistReaction.rejected,
        thunks.fetchPlaylistReactionRejected
      )
      .addCase(thunks.postPlaylistLike.pending, thunks.postPlaylistLikePending)
      .addCase(
        thunks.postPlaylistLike.fulfilled,
        thunks.postPlaylistLikeFulfilled
      )
      .addCase(
        thunks.postPlaylistLike.rejected,
        thunks.postPlaylistLikeRejected
      )
      .addCase(
        thunks.postPlaylistDislike.pending,
        thunks.postPlaylistDislikePending
      )
      .addCase(
        thunks.postPlaylistDislike.fulfilled,
        thunks.postPlaylistDislikeFulfilled
      )
      .addCase(
        thunks.postPlaylistDislike.rejected,
        thunks.postPlaylistDislikeRejected
      )
      .addCase(
        thunks.deletePlaylistReaction.pending,
        thunks.deletePlaylistReactionPending
      )
      .addCase(
        thunks.deletePlaylistReaction.fulfilled,
        thunks.deletePlaylistReactionFulfilled
      )
      .addCase(
        thunks.deletePlaylistReaction.rejected,
        thunks.deletePlaylistReactionRejected
      );
  },
});

export const { setCurrentPlaylist } = playlistDetailsSlice.actions;

export const playlistDetailsReducer = playlistDetailsSlice.reducer;
