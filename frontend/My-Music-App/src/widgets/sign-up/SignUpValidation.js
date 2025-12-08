import { constants } from './constants';

export const validate = (values, backendErrors) => {
  const error = {};
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/i;
  const whiteSpaceRegex = /\s/g;
  const lowerCaseRegex = /(?=.*[a-z])/;
  const upperCaseRegex = /(?=.*[A-Z])/;
  const oneDigitRegex = /(?=.*\d)/;
  const specialCharacterRegex = /(?=.*[@#$%^&-+=()])/;
  const notAllowedRegex = /(?=.*[\\'"])/;

  //  Nickname validation

  if (!values.nickname) {
    error.nickname = 'Please enter your nickname.';
  } else if (whiteSpaceRegex.test(values.nickname)) {
    error.nickname = "Please enter a nickname that doesn't include spaces.";
  } else if (
    !(
      values.nickname.length >= constants.nicknameMinValueLength &&
      values.nickname.length <= constants.nicknameMaxValueLength
    )
  ) {
    error.nickname =
      'Please enter the nickname that includes between 3 and 50 characters.';
  } else if (backendErrors.nicknameExistingError) {
    error.nickname =
      'The nickname you entered is already associated with an existing account. Please sign in or use a different nickname to sign up.';
  }

  // Email validation

  if (!values.email) {
    error.email = 'Please enter an email address.';
  } else if (whiteSpaceRegex.test(values.email)) {
    error.email =
      'Please enter a valid email address without any spaces or special characters.';
  } else if (!emailRegex.test(values.email)) {
    error.email = 'Please enter a valid email domain.';
  } else if (backendErrors.emailExistingError) {
    error.email =
      'The email address you entered is already associated with an existing account. Please sign in or use a different email address to sign up.';
  } else if (backendErrors.emailDomainError) {
    error.email = 'Please enter a valid email domain.';
  } else if (backendErrors.emailInvalidError) {
    error.email =
      'Please enter a valid email address without any spaces or special characters.';
  }

  // Password validation

  if (!values.password) {
    error.password = 'Please enter a password.';
  } else if (values.password.length < constants.passwordMinValueLength) {
    error.password = 'Please enter a password with a minimum of 8 characters.';
  } else if (values.password.length > constants.passwordMaxValueLength) {
    error.password =
      'The password you entered is too long. Please enter a password with a maximum of 128 characters.';
  } else if (!lowerCaseRegex.test(values.password)) {
    error.password =
      'Please enter a password that includes at least one lowercase letter.';
  } else if (!upperCaseRegex.test(values.password)) {
    error.password =
      'Please enter a password that includes at least one uppercase letter.';
  } else if (!oneDigitRegex.test(values.password)) {
    error.password =
      'Please enter a password that includes at least one number.';
  } else if (!specialCharacterRegex.test(values.password)) {
    error.password =
      'Please enter a password that includes at least one special character.';
  } else if (
    notAllowedRegex.test(values.password) ||
    values.password.includes('\\0')
  ) {
    error.password =
      'Please enter the password that does not include characters such as Backslash (\\), Single Quote (\' or \'), Double Quote (" or "), Null Byte (\\0).';
  }

  // Confirm password validation

  if (!values.confirmPassword) {
    error.confirmPassword = 'Please confirm your password.';
  } else if (values.password !== values.confirmPassword) {
    error.confirmPassword =
      'The passwords you entered do not match. Please try again.';
  }

  return error;
};
