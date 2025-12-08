import {
  createBrowserRouter,
  createRoutesFromElements,
  Navigate,
  Route,
} from 'react-router-dom';
import Home from '../pages/home/Home';
import SignUp from '../widgets/sign-up/SignUp';
import SignIn from '../widgets/sign-In/SignIn';
import Main from '../widgets/main-view/MainView';
import PrivateRoute from './PrivateRoute';
import paths from './paths';
import MyPlaylists from '../widgets/my-playlists/MyPlaylists';
import SharedPlaylists from '../widgets/shared-playlists/SharedPlaylists';
import PlaylistDetails from '../widgets/playlist-details/PlaylistDetails';
import { FETCH_PLAYLISTS_TYPES } from '../store/constants';
import PublicPlaylists from '../widgets/public-playlists/PublicPlaylists';
import NonAuthOnlyRoute from './NonAuthOnlyRoute';
import MyAccount from '../widgets/my-account/MyAccount';
import Friends from '../widgets/friends/Friends';
import FriendsTab from '../entities/friends/ui/FriendsTab';
import About from '../entities/about/About';

const {
  home,
  signIn,
  signUp,
  myAccount,
  myPlaylists,
  myPlaylistDetails,
  publicPlaylists,
  publicPlaylistDetails,
  sharedPlaylists,
  sharedPlaylistDetails,
  friends,
  friendsMy,
  friendsSent,
  friendsRequest,
  about,
} = paths;

const router = createBrowserRouter(
  createRoutesFromElements(
    <>
      <Route path={home} element={<Home />}>
        <Route path='' element={<Main />} />
        <Route
          path={signIn}
          element={
            <NonAuthOnlyRoute>
              <SignIn />
            </NonAuthOnlyRoute>
          }
        />
        <Route
          path={signUp}
          element={
            <NonAuthOnlyRoute>
              <SignUp />
            </NonAuthOnlyRoute>
          }
        />
        <Route
          path={myAccount}
          element={
            <PrivateRoute
              isAuthRequired
              errorMessage={`It looks like you don't have permission to view this page. Please sign in to continue.`}
            >
              <MyAccount />
            </PrivateRoute>
          }
        />
        <Route
          path={myPlaylists}
          element={
            <PrivateRoute
              isAuthRequired
              errorMessage={`It looks like you don't have permission to view this page. Please sign in to continue.`}
            >
              <MyPlaylists />
            </PrivateRoute>
          }
        />
        <Route
          path={`${myPlaylistDetails}/:id`}
          element={
            <PrivateRoute
              isAuthRequired
              errorMessage={`This playlist is available for authenticated users only. Please sign in to continue.`}
            >
              <PlaylistDetails
                playlistTypeToDisplay={FETCH_PLAYLISTS_TYPES.MY}
              />
            </PrivateRoute>
          }
        />
        <Route
          path={`${sharedPlaylistDetails}/:id`}
          element={
            <PrivateRoute
              isAuthRequired
              errorMessage={`This playlist is available for authenticated users only. Please sign in to continue.`}
            >
              <PlaylistDetails
                playlistTypeToDisplay={FETCH_PLAYLISTS_TYPES.SHARED}
              />
            </PrivateRoute>
          }
        />
        <Route
          path={sharedPlaylists}
          element={
            <PrivateRoute
              isAuthRequired
              errorMessage={`It looks like you don't have permission to view this page. Please sign in to continue.`}
            >
              <SharedPlaylists />
            </PrivateRoute>
          }
        />
        <Route
          path={`${publicPlaylistDetails}/:id`}
          element={
            <PlaylistDetails
              playlistTypeToDisplay={FETCH_PLAYLISTS_TYPES.PUBLIC}
            />
          }
        />
        <Route path={publicPlaylists} element={<PublicPlaylists />} />
        <Route path={friends} element={<Friends />}>
          <Route path='' element={<Navigate to={friendsRequest} />} />
          <Route
            path={friendsMy}
            element={
              <PrivateRoute
                isAuthRequired
                errorMessage={`It looks like you don't have permission to view this page. Please sign in to continue.`}
              >
                <FriendsTab />
              </PrivateRoute>
            }
          />
          <Route
            path={friendsSent}
            element={
              <PrivateRoute
                isAuthRequired
                errorMessage={`It looks like you don't have permission to view this page. Please sign in to continue.`}
              >
                <FriendsTab />
              </PrivateRoute>
            }
          />
          <Route
            path={friendsRequest}
            element={
              <PrivateRoute
                isAuthRequired
                errorMessage={`It looks like you don't have permission to view this page. Please sign in to continue.`}
              >
                <FriendsTab />
              </PrivateRoute>
            }
          />
        </Route>
        <Route path={about} element={<About />} />
        <Route path='*' element={<h1>Not Found</h1>} />
      </Route>
    </>
  )
);

export default router;
