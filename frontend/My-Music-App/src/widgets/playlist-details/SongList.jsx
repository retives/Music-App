import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { BsThreeDotsVertical } from 'react-icons/bs';
import { RiDeleteBin6Line } from 'react-icons/ri';
import { PiDotBold } from 'react-icons/pi';

import { useDispatch, useSelector } from 'react-redux';
import { userSelector } from '../../store/user/user.selector';

import ModalDialog from '../../shared/ModalDialog';
import { playlistDetailsSelector } from '../../store/playlist-details/playlist-details.selector';
import { deleteSongFromPlaylist } from '../../store/playlist-details/playlist-details.thunks';
import {
  SongsContainer,
  SongItem,
  Song,
  SongCard,
  SongCover,
  SongArtistInfo,
  SongTitle,
  SongInfo,
  VerticalMenu,
  DeleteModal,
  DeleteTag,
  SongImgWrapper,
} from './SongList.styles';
import { capitalizeWords } from '../../store/helpers';
import {
  FALLBACK_TYPES,
  IMAGE_SIZES,
} from '../../features/shared/ImgWrap/constants/constants';

function SongList({ shouldRenderKebabMenu, shouldRenderAddedBy }) {
  // state
  const dispatch = useDispatch();
  const {
    isAuthenticated,
    credentials: { nickname },
  } = useSelector(userSelector);
  const { songs } = useSelector(playlistDetailsSelector);

  const [openModel, setOpenModel] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [idSongToDelete, setIdSongToDelete] = useState(null);

  // Handlers
  const handleOpenModal = () => {
    setIsModalOpen(true);
  };
  const handleCloseModal = () => {
    setIsModalOpen(false);
  };

  const handlerRemove = () => {
    if (!idSongToDelete || !isAuthenticated) return;

    try {
      dispatch(deleteSongFromPlaylist(idSongToDelete));
    } catch (error) {
      console.error(error);
    }

    setOpenModel(null);
  };

  const handleDeleteSong = (songId) => {
    setIdSongToDelete(songId);
    handleOpenModal();
  };

  const verticalMenuToggle = (x) => {
    if (x === openModel) {
      setOpenModel(null);
    } else {
      setOpenModel(x);
    }
  };

  return (
    <div className='SongList'>
      <ModalDialog
        options={{
          isModalOpen,
          actionButtonText: 'Remove Song',
          closeButtonText: 'Cancel',
          title:
            'Are you sure you want to remove this song from playlist? You will not be able to restore it.',
          onAction: handlerRemove,
          onClose: handleCloseModal,
        }}
        className='song-list__modal--remove-song'
      />
      <SongsContainer className='song-list__container scrollbar-on'>
        {songs.map(
          ({ id, attributes: { title, artists, cover, added_by, album } }) => {
            return (
              <SongItem key={id} data-song-id={id}>
                <Song>
                  <SongCard className='song-list__song-card song-card__container'>
                    <SongImgWrapper className='song-card__cover'>
                      <SongCover
                        srcObj={cover}
                        fallbackType={FALLBACK_TYPES.ALBUM}
                        size={IMAGE_SIZES.SMALL}
                        alt='song cover'
                      />
                    </SongImgWrapper>
                    <SongArtistInfo className='SongList__artistInfo song-card__caption'>
                      <SongTitle className='song-card__caption--title'>
                        <p>{title}</p>
                      </SongTitle>
                      <SongInfo>
                        <p className='song-card__caption--album'>{album}</p>
                        <PiDotBold />
                        <p className='song-card__caption--artists'>
                          {artists.join(', ')}
                        </p>
                      </SongInfo>
                      {shouldRenderAddedBy && (
                        <SongInfo className='song-card__caption--added-by'>
                          <p>Added by {capitalizeWords(added_by)}</p>
                        </SongInfo>
                      )}
                    </SongArtistInfo>
                  </SongCard>
                  <VerticalMenu className='song-card__vertical-menu-icon-wrapper'>
                    {(shouldRenderKebabMenu ||
                      (shouldRenderAddedBy && nickname === added_by)) && (
                      <BsThreeDotsVertical
                        onClick={() => {
                          verticalMenuToggle(id);
                        }}
                        className='song-card__vertical-menu-icon'
                      />
                    )}
                    {openModel === id && (
                      <DeleteModal className='song-card__detete-menu delete-menu'>
                        {
                          <DeleteTag onClick={() => handleDeleteSong(id)}>
                            <RiDeleteBin6Line className='delete-menu__icon' />
                            <span className='delete-menu__text'>
                              Remove song from playlist
                            </span>
                          </DeleteTag>
                        }
                      </DeleteModal>
                    )}
                  </VerticalMenu>
                </Song>
              </SongItem>
            );
          }
        )}
      </SongsContainer>
    </div>
  );
}

SongList.propTypes = {
  shouldRenderKebabMenu: PropTypes.bool.isRequired,
  shouldRenderAddedBy: PropTypes.bool.isRequired,
};

export default SongList;
