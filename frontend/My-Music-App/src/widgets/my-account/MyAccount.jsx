import {
  ActionWrap,
  AvatarDeleteIcon,
  AvatarImage,
  AvatarInput,
  AvatarItem,
  AvatarWrap,
  DataWrap,
  DeleteAccountButton,
  DeleteAccountFormText,
  FormInput,
  FormResetButton,
  FormSubmitButton,
  FormText,
  Header,
  InputClearButton,
  PersonalDataForm,
  UploadIcon,
  Wrapper,
} from './MyAccount.styles';
import React, { useCallback, useEffect, useRef, useState } from 'react';
import { AiOutlineCloseCircle } from 'react-icons/ai';
import { useDispatch, useSelector } from 'react-redux';
import {
  deleteMyAccount,
  fetchMyAccount,
  updateMyAccount,
} from '../../store/my-account/my-account.thunks';
import {
  myAccountErrorSelector,
  myAccountLoadingSelector,
  myAccountSelector,
} from '../../store/my-account/my-account.selector';
import { MdPhotoCamera } from 'react-icons/md';
import { isEmpty, validateMyAccount } from './lib/utils/MyAccountValidation';
import Tippy from '@tippyjs/react';
import { toast } from 'react-toastify';
import { baseToastConfig, OneLineMessage } from '../../shared/Toasts';
import {
  DELETE_ACCOUNT_MODAL_MESSAGES,
  DELETE_AVATAR_MODAL_MESSAGES,
  LEAVE_PAGE_CONFIRMATION_MODAL,
  TOAST_MESSAGES,
} from './constants/constants';
import { userSelector } from '../../store/user/user.selector';
import ModalDialog from '../../shared/ModalDialog';
import { useBlocker, useNavigate } from 'react-router-dom';
import {
  DEFAULT_USER_AVATAR,
  FALLBACK_TYPES,
  IMAGE_SIZES,
} from '../../features/shared/ImgWrap/constants/constants';
import { getImgSrc } from '../../features/shared/ImgWrap/lib/getImgSrc';

function MyAccount() {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const toastId = useRef(null);
  const { isAuthenticated: isAuth } = useSelector(userSelector);
  const {
    nickname: initUsername,
    email: initEmail,
    profilePicture: initProfilePicture,
  } = useSelector(myAccountSelector);
  const loading = useSelector(myAccountLoadingSelector);
  const error = useSelector(myAccountErrorSelector);
  const initDetails = {
    nickname: initUsername ?? '',
    email: initEmail ?? '',
    profilePicture: null,
  };
  const [isDetailsModified, setIsDetailsModified] = useState(false);
  const avatarInputRef = useRef(null);
  const [myAccountDetails, setMyAccountDetails] = useState(initDetails);
  const { nickname, email, profilePicture } = myAccountDetails;
  const [myAccountErrors, setMyAccountErrors] = useState({});
  const avatarURL = initProfilePicture
    ? getImgSrc(initProfilePicture, FALLBACK_TYPES.USER, IMAGE_SIZES.LARGE)
    : '';

  const [isSaveClicked, setIsSaveClicked] = useState(false);
  const [modalClassName, setModalClassName] = useState('');
  const [modalOptions, setModalOptions] = useState({
    isModalOpen: false,
    actionButtonText: '',
    closeButtonText: '',
    title: '',
    onClose: () => {},
    onAction: () => {},
  });

  let blocker = useBlocker(
    ({ currentLocation, nextLocation }) =>
      isDetailsModified && currentLocation.pathname !== nextLocation.pathname
  );

  const handleAvatarDeleteModalOpen = () => {
    setModalClassName('modal__delete-avatar');
    setModalOptions({
      ...modalOptions,
      isModalOpen: true,
      actionButtonText: DELETE_AVATAR_MODAL_MESSAGES.ACTION,
      closeButtonText: DELETE_AVATAR_MODAL_MESSAGES.CLOSE,
      title: DELETE_AVATAR_MODAL_MESSAGES.TITLE,
      onAction: handleAvatarDelete,
      onClose: handleModalClose,
    });
  };
  useEffect(() => {
    if (blocker.state === 'blocked') {
      handleLeavePageModalOpen();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [blocker.state]);
  const handleLeavePageModalOpen = () => {
    setModalClassName('modal__leave-page');
    setModalOptions({
      ...modalOptions,
      isModalOpen: true,
      actionButtonText: LEAVE_PAGE_CONFIRMATION_MODAL.ACTION,
      closeButtonText: LEAVE_PAGE_CONFIRMATION_MODAL.CLOSE,
      title: LEAVE_PAGE_CONFIRMATION_MODAL.TITLE,
      onAction: handleLeavePage,
      onClose: handleStayOnPage,
    });
  };
  const handleModalClose = () => {
    setModalOptions({ ...modalOptions, isModalOpen: false });
  };
  const handleStayOnPage = () => blocker.reset();
  const handleLeavePage = () => blocker.proceed();

  const handleDeleteAccountModalOpen = () => {
    setModalClassName('modal__delete-account');
    setModalOptions({
      ...modalOptions,
      isModalOpen: true,
      actionButtonText: DELETE_ACCOUNT_MODAL_MESSAGES.ACTION,
      closeButtonText: DELETE_ACCOUNT_MODAL_MESSAGES.CLOSE,
      title: DELETE_ACCOUNT_MODAL_MESSAGES.TITLE,
      onAction: handleDeleteAccount,
      onClose: handleModalClose,
    });
  };

  const handleDeleteAccount = () => {
    dispatch(deleteMyAccount()).then(() => {
      navigate('/');
    });
  };

  const notify = useCallback(() => {
    toastId.current = toast(
      <OneLineMessage message={TOAST_MESSAGES.PENDING} />,
      baseToastConfig
    );
  }, []);

  const notifyError = useCallback(() => {
    toast.update(toastId.current, {
      type: toast.TYPE.ERROR,
      autoClose: 2000,
      render: <OneLineMessage message={TOAST_MESSAGES.ERROR} />,
    });
  }, []);

  const notifySuccess = useCallback(() => {
    toast.update(toastId.current, {
      type: toast.TYPE.SUCCESS,
      autoClose: 2000,
      render: <OneLineMessage message={TOAST_MESSAGES.SUCCESS} />,
    });
  }, []);

  useEffect(() => {
    if (isSaveClicked && loading) {
      notify();
    }
    if (isSaveClicked && !loading && error) {
      notifyError();
      setIsSaveClicked(false);
    }
    if (isSaveClicked && !loading && !error) {
      notifySuccess();
      setIsSaveClicked(false);
      setIsDetailsModified(false);
    }
  }, [isSaveClicked, loading, error, notify, notifyError, notifySuccess]);

  const handleInputPaste = (e) => {
    e.preventDefault();
    const { name } = e.target;
    setMyAccountDetails({
      ...myAccountDetails,
      [name]: e.clipboardData.getData('text/plain'),
    });
  };
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setMyAccountDetails({ ...myAccountDetails, [name]: value });
  };
  const clearInput = (e) => {
    const { name } = e.currentTarget;
    setMyAccountDetails({ ...myAccountDetails, [name]: '' });
  };

  const handleUploadClick = () => {
    avatarInputRef.current.click();
    setMyAccountErrors({ ...myAccountErrors, profilePicture: '' });
  };

  const handleAvatarChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    if (!myAccountErrors.profilePicture) {
      setMyAccountDetails({
        ...myAccountDetails,
        profilePicture: file,
      });
    }
    setIsDetailsModified(true);
  };

  const handleAvatarDelete = async () => {
    const file = await fetchAvatar(DEFAULT_USER_AVATAR.JPG);
    setMyAccountDetails({
      ...myAccountDetails,
      profilePicture: file,
    });
    setIsDetailsModified(true);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setIsSaveClicked(true);
    let formData = new FormData();
    formData.append('nickname', nickname);
    formData.append('email', email);
    formData.append('profile_picture', profilePicture);
    dispatch(updateMyAccount(formData));
  };

  const handleReset = async () => {
    if (!isDetailsModified) return;
    const file = await fetchAvatar(avatarURL);
    setMyAccountDetails({
      nickname: initUsername,
      email: initEmail,
      profilePicture: file,
    });
  };

  async function fetchAvatar(url) {
    try {
      const data = await fetch(url);
      if (!data.ok)
        throw new Error('Fetch user avatar from url to file failed');
      const buffer = await data.arrayBuffer();
      const blob = new Blob([buffer], {
        type: initProfilePicture?.metadata.mime_type,
      });
      const file = new File([blob], initProfilePicture?.metadata.filename, {
        type: initProfilePicture?.metadata.mime_type,
      });
      return file;
    } catch (error) {
      console.error(error);
    }
  }

  async function addFileToState() {
    const file = await fetchAvatar(avatarURL);
    setMyAccountDetails({ ...myAccountDetails, profilePicture: file });
  }

  useEffect(() => {
    if (!isAuth) return;
    dispatch(fetchMyAccount());
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isAuth]);

  useEffect(() => {
    if (!avatarURL) {
      return;
    }
    addFileToState();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (initUsername === '' || initEmail === '') {
      return;
    }
    if (nickname !== initDetails.nickname || email !== initDetails.email) {
      setIsDetailsModified(true);
    } else {
      setIsDetailsModified(false);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [nickname, email]);

  useEffect(() => {
    setMyAccountErrors(validateMyAccount(myAccountDetails));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [nickname, email, profilePicture]);

  return (
    <Wrapper className='my-account__wrapper'>
      {modalOptions.isModalOpen && (
        <ModalDialog className={modalClassName} options={modalOptions} />
      )}
      <PersonalDataForm
        name='personal-data-form'
        onSubmit={handleSubmit}
        className='personal-data-form'
      >
        <Header className='personal-data-form__header'>Personal data</Header>
        <AvatarWrap className='personal-data-form__avatar-wrap'>
          <FormText>My avatar</FormText>
          <Tippy
            placement='right'
            content={myAccountErrors.profilePicture}
            disabled={!myAccountErrors.profilePicture}
            animation='fade'
            duration='500'
            className='personal-data-form__profile-picture-tooltip'
          >
            <AvatarItem className='personal-data-form__profile-picture'>
              {myAccountDetails.profilePicture &&
              !myAccountErrors.profilePicture ? (
                <AvatarImage
                  src={URL.createObjectURL(myAccountDetails.profilePicture)}
                  alt='User avatar'
                />
              ) : (
                <AvatarImage
                  src={getImgSrc(
                    initProfilePicture,
                    FALLBACK_TYPES.USER,
                    IMAGE_SIZES.LARGE
                  )}
                  alt='Default user avatar'
                />
              )}
              <UploadIcon
                onClick={handleUploadClick}
                className='personal-data-form__profile-picture-upload-icon'
              >
                <MdPhotoCamera size='30' fill='#9747FF' />
                <label htmlFor='avatar'></label>
                <AvatarInput
                  type='file'
                  id='avatar'
                  ref={avatarInputRef}
                  onChange={handleAvatarChange}
                  accept='image/jpeg, image/png, image/jpg, image/svg'
                  className='personal-data-form__profile-picture-input'
                />
              </UploadIcon>
              <AvatarDeleteIcon
                onClick={handleAvatarDeleteModalOpen}
                className='personal-data-form__profile-picture-delete-icon'
              >
                <AiOutlineCloseCircle size='52' fill='#EC928E' />
              </AvatarDeleteIcon>
            </AvatarItem>
          </Tippy>
        </AvatarWrap>
        <DataWrap className='personal-data-form__user-text-data-wrap'>
          <FormText>My data</FormText>
          <Tippy
            placement='right'
            content={myAccountErrors.nickname}
            disabled={!myAccountErrors.nickname}
            animation='fade'
            duration='500'
            className='personal-data-form__nickname-tooltip'
          >
            <fieldset>
              <legend>Nickname</legend>
              <label htmlFor='nickname'></label>
              <FormInput
                type='text'
                name='nickname'
                id='nickname'
                required
                value={myAccountDetails.nickname}
                onChange={handleInputChange}
                onPaste={handleInputPaste}
                className='personal-data-form__nickname-input'
              />
              <InputClearButton
                type={'reset'}
                form={'personal-data-form'}
                name='nickname'
                className='personal-data-form__nickname-input-clear-btn'
                onClick={clearInput}
              >
                <AiOutlineCloseCircle className='clear-icon' />
              </InputClearButton>
            </fieldset>
          </Tippy>
          <Tippy
            placement='right'
            content={myAccountErrors.email}
            disabled={!myAccountErrors.email}
            animation='fade'
            duration='500'
            className='personal-data-form__email-tooltip'
          >
            <fieldset>
              <legend>Email</legend>
              <label htmlFor='email'></label>
              <FormInput
                type='email'
                name='email'
                id='email'
                required
                value={myAccountDetails.email}
                onChange={handleInputChange}
                onPaste={handleInputPaste}
                className='personal-data-form__email-input'
              />
              <InputClearButton
                type={'reset'}
                form={'personal-data-form'}
                name='email'
                className='personal-data-form__email-input-clear-btn'
                onClick={clearInput}
              >
                <AiOutlineCloseCircle className='clear-icon' />
              </InputClearButton>
            </fieldset>
          </Tippy>
        </DataWrap>
        <ActionWrap className='personal-data-form__action-btn-wrap'>
          <FormSubmitButton
            type='submit'
            name='form-save-btn'
            disabled={!isDetailsModified || !isEmpty(myAccountErrors)}
            onSubmit={handleSubmit}
            className='personal-data-form__submit-btn'
          >
            Save
          </FormSubmitButton>
          <FormResetButton
            type='reset'
            name='form-cancel-btn'
            onClick={handleReset}
            className='personal-data-form__reset-btn'
          >
            Cancel
          </FormResetButton>
        </ActionWrap>
      </PersonalDataForm>
      <PersonalDataForm
        name='delete-account-form'
        className='delete-account-form'
      >
        <DeleteAccountFormText>Actions with the account</DeleteAccountFormText>
        <ActionWrap className='delete-account-form__action-btn-wrap'>
          <DeleteAccountButton
            type='button'
            name='delete-account-btn'
            className='delete-account-form__btn'
            disabled={loading}
            onClick={handleDeleteAccountModalOpen}
          >
            Delete account
          </DeleteAccountButton>
        </ActionWrap>
      </PersonalDataForm>
    </Wrapper>
  );
}

export default MyAccount;
