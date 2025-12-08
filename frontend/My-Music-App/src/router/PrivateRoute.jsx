import React, { useRef } from 'react';
import PropTypes from 'prop-types';
import { userSelector } from '../store/user/user.selector';
import { useSelector } from 'react-redux';
import { Navigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import { OneLineMessage, baseToastConfig } from '../shared/Toasts';
import paths from './paths';

function PrivateRoute({ isAuthRequired, errorMessage, children }) {
  const { isAuthenticated, isRehydrated, isRemembered } =
    useSelector(userSelector);
  const toastId = useRef(null);
  const customId = 'custom-id-signin-requir'; //prevent double toast
  const notify = () => {
    toastId.current = toast(<OneLineMessage message={errorMessage} />, {
      toastId: customId,
      ...baseToastConfig,
      type: toast.TYPE.INFO,
      autoClose: 2000,
    });
  };

  if (!isRehydrated || (isRemembered && !isAuthenticated)) return null; // prevent rendering children before rehydration and tocken refreshing

  if (isAuthRequired && !isAuthenticated) {
    // NOTICE: whean adding a new private routes rules, make sure to add return statement with some logic, coz default behavior is to render children
    notify();
    return <Navigate to={paths.signIn} />;
  }

  return <>{children}</>;
}

PrivateRoute.propTypes = {
  isAuthRequired: PropTypes.bool,
  errorMessage: PropTypes.string,
  children: PropTypes.node,
};

export default PrivateRoute;
