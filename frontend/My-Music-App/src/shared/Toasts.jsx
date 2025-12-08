import React from 'react';
import PropTypes from 'prop-types';
import { ToatsMsg } from './Toasts.styles';
import { toast } from 'react-toastify';

export const baseToastConfig = {
  position: 'top-center',
  autoClose: 5000,
  hideProgressBar: false,
  closeOnClick: true,
  pauseOnHover: true,
  draggable: true,
  progress: undefined,
  theme: 'dark',
};

export const playlistReactionErrorToastConfig = {
  ...baseToastConfig,
  autoClose: 2000,
  type: toast.TYPE.ERROR,
};

export const commentErrorToastConfig = {
  ...baseToastConfig,
  position: 'bottom-right',
  autoClose: 2000,
  type: toast.TYPE.ERROR,
};

export const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

export function OneLineMessage({ message, className }) {
  return (
    <ToatsMsg className={`${className ?? ''}`}>
      <p>{message}</p>
    </ToatsMsg>
  );
}

OneLineMessage.propTypes = {
  message: PropTypes.string.isRequired,
  className: PropTypes.string,
};

export function MessageWithChildren({ children, className }) {
  return <ToatsMsg className={`${className ?? ''}`}>{children}</ToatsMsg>;
}

MessageWithChildren.propTypes = {
  children: PropTypes.node.isRequired,
  className: PropTypes.string,
};

export function LogoutPendingMessage() {
  return (
    <ToatsMsg className='toast__logout--pending'>
      <p>Logging out...</p>
    </ToatsMsg>
  );
}

export function LogoutSuccessMessage() {
  return (
    <ToatsMsg className='toast__logout--success'>
      <p>You have been successfully logged out.</p>
      <p>Come back anytime!</p>
    </ToatsMsg>
  );
}

export function LogoutErrorMessage() {
  return (
    <ToatsMsg className='toast__logout--error'>
      <p>Sorry, we encountered an error while logging you out.</p>
      <p>Please try again later.</p>
    </ToatsMsg>
  );
}

export function LoginSuccessMessage() {
  return (
    <ToatsMsg className='toast__login--success'>
      <p>You have been successfully logged in.</p>
      <p>Welcome back!</p>
    </ToatsMsg>
  );
}

export function PlaylistTypeChangePendingMessage() {
  return (
    <ToatsMsg className='toast__playlist-type-change--pending'>
      <p>Changing playlist type...</p>
    </ToatsMsg>
  );
}

export function PlaylistTypeChangeSuccessMessage() {
  return (
    <ToatsMsg className='toast__playlist-type-change--success'>
      <p>Playlist type has been successfully changed.</p>
    </ToatsMsg>
  );
}

export function PlaylistTypeChangeErrorMessage() {
  return (
    <ToatsMsg className='toast__playlist-type-change--error'>
      <p>Oops, looks like something went wrong.</p>
      <p>Please try again later.</p>
    </ToatsMsg>
  );
}
