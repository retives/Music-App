import { createSelector } from '@reduxjs/toolkit';

const friendsSelector = (state) => state.friendsSlice;

export const friendsLoadingSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.loading
);

export const friendsErrorSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.error
);

export const friendsSuccessMessageSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.successMessage
);

export const shouldRefetchFriendsSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.shouldRefetchFriends
);

export const friendsCTAClickedSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.friendsCTAClicked
);

export const friendsCTAClickedFriendNameSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.friendsCTAClickedFriendName
);

export const friendsAcceptedSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.friendsAccepted
);

export const friendsAcceptedPaginationDataSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.friendsAcceptedPaginationData
);

export const friendsSentSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.friendsSent
);

export const friendsSentPaginationDataSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.friendsSentPaginationData
);

export const friendsRecivedSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.friendsRecived
);

export const friendsRecivedPaginationDataSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.friendsRecivedPaginationData
);

export const addFriendLoadingSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.addFriendLoading
);

export const addFriendErrorSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.addFriendError
);

export const numOfRecivedFriendRequestsSelector = createSelector(
  friendsSelector,
  (friendsSlice) => friendsSlice.numOfRecivedFriendRequests
);
