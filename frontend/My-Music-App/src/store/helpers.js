/**
 * Parses a string to extract the number of likes and dislikes.
 *
 * @param {string | null} str - The string to parse. It should contain 'Likes: {number}' and 'Dislikes: {number}'.
 * @returns {Object} An object with 'likes' and 'dislikes' properties, each containing the parsed number of likes and dislikes. If no match is found, the value will be 0.
 */
export const parseLikesDislikes = (str) => {
  const likesMatch = str.match(/Likes: (\d+)/);
  const dislikesMatch = str.match(/Dislikes: (\d+)/);
  return {
    likes: likesMatch ? parseInt(likesMatch[1]) : 0,
    dislikes: dislikesMatch ? parseInt(dislikesMatch[1]) : 0,
  };
};

/**
 * Formats a date string into the format "DD MMM YYYY".
 *
 * @param {string} dateString - The date string to format. It should be in a format that can be parsed by the Date constructor.
 * @param {string} [locale="en-GB"] - The locale to use for formatting the date. Defaults to "en-GB".
 * @returns {string} The formatted date string.
 */
export const formatDateDDmmmYYYY = (dateString, locale = 'en-GB') => {
  const date = new Date(dateString);
  if (isNaN(date.getTime())) throw new Error('Invalid date');

  const dateFormatter = new Intl.DateTimeFormat(locale, {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  });
  return dateFormatter.format(date);
};

export const setUpCookie = (cookieName, cookieValue, cookieExpiresAt) => {
  document.cookie = `${cookieName}=${cookieValue}; max-age=${cookieExpiresAt}; path=/ SameSite=Strict; Secure`;
};

export const deleteCookie = (cookieName) => {
  document.cookie = `${cookieName}=; max-age=0; path=/ SameSite=Strict; Secure`;
};

/**
 * Capitalize the first letter of a string and lowercase the rest.
 *
 * @param {string} word - The string to capitalize.
 * @throws {Error} Throws an error if the input is not a string.
 * @returns {string} The capitalized string.
 */
export const capitalize = (word) => {
  if (typeof word !== 'string')
    throw new Error('Invalid input: Argument must be a string');
  return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
};

export const nicknameDividers = [`,`, `.`, `_`, `|`, `/`];
/**
 * Capitalize the first letter of each word in a string, replacing dividers with spaces.
 * Retains multiple dividers' behavior by replacing multiple instanses in a row with a single space.
 *
 * @param {string} input - The string to process.
 * @throws {Error} Throws an error if the input is not a string.
 * @returns {string} The processed string with words capitalized and dividers replaced with spaces.
 */
export const capitalizeWords = (input) => {
  if (typeof input !== 'string')
    throw new Error('Invalid input: Argument must be a string');

  const dividersRegex = new RegExp(`[${nicknameDividers.join('')}]{1,}`, 'g');
  const hasDivider = nicknameDividers.some((divider) =>
    input.includes(divider)
  );
  if (!hasDivider) return capitalize(input);

  const words = input.replace(dividersRegex, ' ').split(' ');
  const capitalizedWords = words.map((word) => capitalize(word));
  return capitalizedWords.join(' ').trim();
};
