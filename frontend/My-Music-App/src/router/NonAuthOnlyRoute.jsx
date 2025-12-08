import React from 'react';
import PropTypes from 'prop-types';
import { userSelector } from '../store/user/user.selector';
import { useSelector } from 'react-redux';
import { Navigate } from 'react-router-dom';
import paths from './paths';

function NonAuthOnlyRoute({ children }) {
  const { isAuthenticated } = useSelector(userSelector);
  if (isAuthenticated) {
    return <Navigate to={paths.home} />;
  }
  return <>{children}</>;
}

NonAuthOnlyRoute.propTypes = {
  children: PropTypes.node,
};

export default NonAuthOnlyRoute;
