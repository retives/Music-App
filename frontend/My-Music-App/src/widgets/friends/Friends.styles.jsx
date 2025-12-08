import styled from 'styled-components';
import { flexHorizontalCenter } from '../../shared/Shared.styles';
import { NavLink } from 'react-router-dom';

export const FriendsContainer = styled.section`
  font-family: 'Roboto', sans-serif;
  font-style: normal;
`;

export const FriendsTitleContainer = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 24px;
`;
export const FriendsTitle = styled.h3`
  color: var(--m-3-white, #fff);
  font-size: 22px;
  font-weight: 400;
  line-height: 28px;
`;

export const FriendsMenu = styled.nav`
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  // Divider
  border: none;
  border-bottom: 1px solid #36343b;
  margin-bottom: 24px;
`;

export const FriendsMenuItem = styled(NavLink)`
  color: var(--m-3-sys-dark-on-surface-variant, #cac4d0);
  ${flexHorizontalCenter}
  font-size: 14px;
  font-weight: 500;
  line-height: 20px;
  letter-spacing: 0.1px;
  padding: 14px 16px;

  &.active {
    border-bottom: 2px solid #d0bcff;
  }
`;
