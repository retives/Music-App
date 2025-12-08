import { createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';
import {
  ERROR_RESPONSE_CODES,
  ERROR_RESPONSE_MESSAGES,
  MY_ACCOUNT_URL,
} from '../constants';
import { myAccountSlice } from './my-account.reducer';

export const fetchMyAccount = createAsyncThunk(
  'myAccountSlice/fetchMyAccount',
  async (_, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      const response = await axios({
        url: `${MY_ACCOUNT_URL}`,
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
        transformResponse: [
          (responseData) => {
            const {
              user: {
                data: {
                  attributes: {
                    nickname,
                    email,
                    profile_picture: profilePicture,
                  },
                },
              },
            } = JSON.parse(responseData);
            return { nickname, email, profilePicture };
          },
        ],
      });
      return {
        myAccount: response.data,
      };
    } catch (error) {
      if (error.response.status === ERROR_RESPONSE_CODES.UNAUTHORIZED)
        throw new Error(ERROR_RESPONSE_MESSAGES.UNAUTHORIZED);
      throw error.response.data.details;
    }
  }
);

export const fetchMyAccountPending = (state) => {
  state.loading = true;
  state.error = null;
};

export const fetchMyAccountFulfilled = (state, action) => {
  state.loading = false;
  state.myAccount = action.payload.myAccount;
};

export const fetchMyAccountRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const updateMyAccount = createAsyncThunk(
  'myAccountSlice/updateMyAccount',
  async (formData, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      const response = await axios({
        url: `${MY_ACCOUNT_URL}`,
        method: 'PUT',
        data: formData,
        headers: {
          Accept: '*/*',
          'Content-Type': 'multipart/form-data',
          Authorization: `Bearer ${accessToken}`,
        },
        transformResponse: [
          (responseData) => {
            const {
              data: {
                attributes: {
                  nickname,
                  email,
                  profile_picture: profilePicture,
                },
              },
            } = JSON.parse(responseData);
            return { nickname, email, profilePicture };
          },
        ],
      });
      return {
        myAccount: response.data,
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

export const updateMyAccountPending = (state) => {
  state.loading = true;
  state.error = null;
};

export const updateMyAccountFulfilled = (state, action) => {
  state.loading = false;
  state.myAccount = action.payload.myAccount;
};

export const updateMyAccountRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const deleteMyAccount = createAsyncThunk(
  'myAccountSlice/deleteMyAccount',
  async (_, { getState }) => {
    const accessToken = getState().user.accessToken;
    try {
      await axios({
        url: `${MY_ACCOUNT_URL}`,
        method: 'DELETE',
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
      });
    } catch (error) {
      if (error.response.status === ERROR_RESPONSE_CODES.UNAUTHORIZED)
        throw new Error(ERROR_RESPONSE_MESSAGES.UNAUTHORIZED);
      throw error.response.data.errors;
    }
  }
);

export const deleteMyAccountPending = (state) => {
  state.loading = true;
  state.error = null;
};

export const deleteMyAccountFulfilled = (state) => {
  state.loading = false;
  myAccountSlice.actions.resetMyAccount(state);
};

export const deleteMyAccountRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};
