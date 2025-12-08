import { createSlice } from '@reduxjs/toolkit';
import * as thunks from './friends.thunks';
import { FRIENDS_CTA_BUTTON_TYPES } from '../../entities/friends/constants/constants';

const initialState = {
  loading: false,
  error: null,
  successMessage: null,
  shouldRefetchFriends: false,
  friendsCTAClicked: FRIENDS_CTA_BUTTON_TYPES.NONE,
  friendsCTAClickedFriendName: '',
  friendsAccepted: [],
  friendsAcceptedPaginationData: {},
  friendsSent: [],
  friendsSentPaginationData: {},
  friendsRecived: [],
  friendsRecivedPaginationData: {},
  addFriendLoading: false,
  addFriendError: null,
  numOfRecivedFriendRequests: null,
};

export const friendsSlice = createSlice({
  name: 'friendsSlice',
  initialState: initialState,
  reducers: {
    setShouldRefetchFriends: (state, action) => {
      state.shouldRefetchFriends = action.payload;
    },
    setFriendsSuccessMessage: (state, action) => {
      state.successMessage = action.payload;
    },
    setFriendsCTAClicked: (state, action) => {
      state.friendsCTAClicked = action.payload;
    },
    setFriendsCTAClickedFriendName: (state, action) => {
      state.friendsCTAClickedFriendName = action.payload;
    },
    setAddFriendError: (state, action) => {
      state.addFriendError = action.payload;
    },
  },

  extraReducers: (builder) => {
    builder
      .addCase(
        thunks.fetchFriendsAccepted.pending,
        thunks.fetchFriendsAcceptedPending
      )
      .addCase(
        thunks.fetchFriendsAccepted.fulfilled,
        thunks.fetchFriendsAcceptedFulfilled
      )
      .addCase(
        thunks.fetchFriendsAccepted.rejected,
        thunks.fetchFriendsAcceptedRejected
      )
      .addCase(thunks.fetchFriendsSent.pending, thunks.fetchFriendsSentPending)
      .addCase(
        thunks.fetchFriendsSent.fulfilled,
        thunks.fetchFriendsSentFulfilled
      )
      .addCase(
        thunks.fetchFriendsSent.rejected,
        thunks.fetchFriendsSentRejected
      )
      .addCase(
        thunks.fetchFriendsRecived.pending,
        thunks.fetchFriendsRecivedPending
      )
      .addCase(
        thunks.fetchFriendsRecived.fulfilled,
        thunks.fetchFriendsRecivedFulfilled
      )
      .addCase(
        thunks.fetchFriendsRecived.rejected,
        thunks.fetchFriendsRecivedRejected
      )
      .addCase(
        thunks.fetchAcceptFriendship.pending,
        thunks.fetchAcceptFriendshipPending
      )
      .addCase(
        thunks.fetchAcceptFriendship.fulfilled,
        thunks.fetchAcceptFriendshipFulfilled
      )
      .addCase(
        thunks.fetchAcceptFriendship.rejected,
        thunks.fetchAcceptFriendshipRejected
      )
      .addCase(
        thunks.fetchDeleteFriendship.pending,
        thunks.fetchDeleteFriendshipPending
      )
      .addCase(
        thunks.fetchDeleteFriendship.fulfilled,
        thunks.fetchDeleteFriendshipFulfilled
      )
      .addCase(
        thunks.fetchDeleteFriendship.rejected,
        thunks.fetchDeleteFriendshipRejected
      )
      .addCase(thunks.fetchAddFriend.pending, thunks.fetchAddFriendPending)
      .addCase(thunks.fetchAddFriend.fulfilled, thunks.fetchAddFriendFulfilled)
      .addCase(thunks.fetchAddFriend.rejected, thunks.fetchAddFriendRejected);
  },
});

export const {
  setShouldRefetchFriends,
  setFriendsSuccessMessage,
  setFriendsCTAClicked,
  setFriendsCTAClickedFriendName,
  setAddFriendError,
} = friendsSlice.actions;

export const friendsReducer = friendsSlice.reducer;
