import React from 'react';
import {
  FriendsContainer,
  FriendsMenu,
  FriendsMenuItem,
  FriendsTitle,
  FriendsTitleContainer,
} from './Friends.styles';
import { Outlet } from 'react-router-dom';
import paths from '../../router/paths';
import AddFriend from '../../features/friends/ui/AddFriend';

const { friends, friendsMy, friendsSent, friendsRequest } = paths;

function Friends() {
  return (
    <FriendsContainer className='friends__container'>
      <FriendsTitleContainer className='friends__title-container'>
        <FriendsTitle className='friends__title-text'>Friends</FriendsTitle>
        <AddFriend className='friends__title-btn' />
      </FriendsTitleContainer>
      <FriendsMenu className='friends__nav-tabs'>
        <FriendsMenuItem
          to={`${friends}/${friendsSent}`}
          className='friends__nav-tab--sent'
        >
          Sent by me
        </FriendsMenuItem>
        <FriendsMenuItem
          to={`${friends}/${friendsRequest}`}
          className='friends__nav-tab--request'
        >
          Friends request
        </FriendsMenuItem>
        <FriendsMenuItem
          to={`${friends}/${friendsMy}`}
          className='friends__nav-tab--my'
        >
          My Friends
        </FriendsMenuItem>
      </FriendsMenu>
      <Outlet />
    </FriendsContainer>
  );
}

export default Friends;
