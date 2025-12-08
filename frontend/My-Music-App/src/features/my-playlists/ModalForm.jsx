import React, { useEffect, useRef, useState } from 'react';
import PropTypes from 'prop-types';

import uploadImage from '../../shared/assets/uploadImage.svg';
import closeLogo from '../../shared/assets/closeLogo.svg';
import { IoCloseCircleOutline } from 'react-icons/io5';

import { validate } from '../shared/CreateNewPlaylistValidation';
import ModalDialog from '../../shared/ModalDialog';

import {
  CloseButton,
  CoverImage,
  DeleteLogoButton,
  DescriptionContainer,
  DescriptionInput,
  Details,
  FileInput,
  Form,
  FormLabel,
  Header,
  LogoItem,
  LogoWrap,
  EditPlaylistModalContainer,
  NameContainer,
  NameInput,
  PlaylistDescriptionWrap,
  PlaylistNameWrap,
  SubmitButton,
  Title,
  ValidationLabel,
} from './ModalForm.styles';
import { getImgSrc } from '../shared/ImgWrap/lib/getImgSrc';
import {
  FALLBACK_TYPES,
  IMAGE_SIZES,
} from '../shared/ImgWrap/constants/constants';

function ModalForm({ options }) {
  const {
    isModalFormOpen,
    onAction,
    onClose,
    modalPlaylistId,
    playlist,
    modalTitle,
    actionButtonText,
  } = options;

  const imageInputRef = useRef(null); // dialog reference
  const formRef = useRef(null); // form reference
  // const

  useEffect(() => {
    if (isModalFormOpen) {
      formRef.current.showModal();
    } else {
      formRef.current.close();
    }
  }, [isModalFormOpen]);

  const initialValues = {
    playlistLogo: '',
    playlistName: playlist?.attributes?.name ?? '',
    description: playlist?.attributes?.description ?? '',
  };
  const [playlistDetails, setPlaylistDetails] = useState(initialValues);
  const [createPlaylistErrors, setCreatePlaylistErrors] = useState({});
  const [modalDialogOptions, setModalDialogOptions] = useState({
    isModalOpen: false,
    actionButtonText: '',
    closeButtonText: '',
    title: '',
    onAction: () => {},
    onClose: () => {},
  });

  useEffect(() => {
    setCreatePlaylistErrors(validate(playlistDetails));
  }, [playlistDetails]);

  const logo = playlist?.attributes?.logo || null;
  const coverURL = playlist?.attributes?.logo
    ? getImgSrc(logo, FALLBACK_TYPES.PLAYLIST, IMAGE_SIZES.LARGE)
    : '';
  const shouldRenderDeleteLogoButton = !!playlistDetails.playlistLogo;

  useEffect(() => {
    if (!coverURL) return;

    addFileToState();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function fetchImage(url) {
    try {
      const data = await fetch(url);
      if (!data.ok)
        throw new Error('Fetch playlist conver from url to file failed');
      const buffer = await data.arrayBuffer();
      const blob = new Blob([buffer], { type: logo.metadata.mime_type });
      const file = new File([blob], logo.metadata.filename, {
        type: logo.metadata.mime_type,
      });
      return file;
    } catch (error) {
      console.error(error);
    }
  }

  async function addFileToState() {
    const file = await fetchImage(coverURL);
    setPlaylistDetails({ ...playlistDetails, playlistLogo: file });
  }

  const handleConfirmationDialog = () => {
    onClose();
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setPlaylistDetails({ ...playlistDetails, [name]: value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    let formData = new FormData();
    let playlistId = modalPlaylistId;
    formData.append('name', playlistDetails.playlistName);
    formData.append('logo', playlistDetails.playlistLogo);
    formData.append('description', playlistDetails.description);
    const data = { formData, playlistId };
    onAction(data);
    onClose();
  };

  const handleImageClick = () => {
    imageInputRef.current.click();
    setCreatePlaylistErrors({ ...createPlaylistErrors, playlistLogo: '' });
  };

  const deleteImageClick = () => {
    setPlaylistDetails({ ...playlistDetails, playlistLogo: '' });
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    if (!createPlaylistErrors.playlistLogo) {
      setPlaylistDetails({ ...playlistDetails, playlistLogo: file });
    }
  };

  const handleCloseModalDialog = () => {
    setModalDialogOptions({
      ...modalDialogOptions,
      isModalOpen: false,
    });
  };

  const handleOpenDiscardModal = () => {
    setModalDialogOptions({
      ...modalDialogOptions,
      isModalOpen: true,
      actionButtonText: 'Discard',
      closeButtonText: 'Cancel',
      title: 'Are you sure you want to discard these changes?',
      onAction: handleConfirmationDialog,
      onClose: handleCloseModalDialog,
    });
  };

  const handleOpenDeleteLogoModal = () => {
    setModalDialogOptions({
      ...modalDialogOptions,
      isModalOpen: true,
      actionButtonText: 'Yes',
      closeButtonText: 'No',
      title: 'Are you sure to want to delete the logo??',
      onAction: deleteImageClick,
      onClose: handleCloseModalDialog,
    });
  };

  return (
    <EditPlaylistModalContainer ref={formRef} className='ModalForm__container'>
      <ModalDialog
        className='modal__delete-playlist'
        options={modalDialogOptions}
      />
      <Header>
        <Title className='ModalForm__title'>{modalTitle}</Title>
        <CloseButton
          className='ModalForm__closeButton'
          onClick={handleOpenDiscardModal}
        >
          <img src={closeLogo} alt='button to close modal' />
        </CloseButton>
      </Header>
      <Details>
        <Form onSubmit={handleSubmit}>
          <LogoItem className='ModalForm__logoItem'>
            <LogoWrap onClick={handleImageClick}>
              {playlistDetails.playlistLogo &&
              !createPlaylistErrors.playlistLogo ? (
                <CoverImage
                  src={URL.createObjectURL(playlistDetails.playlistLogo)}
                  alt='Playlist Logo'
                />
              ) : (
                <CoverImage src={uploadImage} alt='Playlist Logo' />
              )}
              <FileInput
                type='file'
                ref={imageInputRef}
                onChange={handleImageChange}
                accept='image/jpeg, image/png, image/jpg, image/svg'
              />
            </LogoWrap>
            <ValidationLabel>
              {createPlaylistErrors.playlistLogo}
            </ValidationLabel>
            {shouldRenderDeleteLogoButton && (
              <DeleteLogoButton
                type='button'
                className='ModalForm__deleteLogoButton'
              >
                <IoCloseCircleOutline onClick={handleOpenDeleteLogoModal} />
              </DeleteLogoButton>
            )}
          </LogoItem>
          <NameContainer>
            <FormLabel>Playlist name</FormLabel>
            <PlaylistNameWrap>
              <NameInput
                className='ModalForm__inputName'
                type='text'
                name='playlistName'
                value={playlistDetails.playlistName}
                onChange={handleChange}
              />
              <ValidationLabel>
                {createPlaylistErrors.playlistName}
              </ValidationLabel>
            </PlaylistNameWrap>
          </NameContainer>
          <DescriptionContainer>
            <FormLabel>Description</FormLabel>
            <PlaylistDescriptionWrap>
              <DescriptionInput
                className='ModalForm__inputDescription'
                type='text'
                name='description'
                rows='4'
                cols='50'
                value={playlistDetails.description || ''}
                onChange={handleChange}
              />
              <ValidationLabel>
                {createPlaylistErrors.description}
              </ValidationLabel>
            </PlaylistDescriptionWrap>
          </DescriptionContainer>
          <SubmitButton
            className='ModalForm__submitButton'
            type='submit'
            onSubmit={handleSubmit}
          >
            {actionButtonText}
          </SubmitButton>
        </Form>
      </Details>
    </EditPlaylistModalContainer>
  );
}

ModalForm.propTypes = {
  options: PropTypes.shape({
    isModalFormOpen: PropTypes.bool.isRequired,
    onAction: PropTypes.func.isRequired,
    onClose: PropTypes.func.isRequired,
    actionButtonText: PropTypes.string.isRequired,
    modalTitle: PropTypes.string.isRequired,
    modalPlaylistId: PropTypes.string,
    playlist: PropTypes.object,
  }).isRequired,
};

export default ModalForm;
