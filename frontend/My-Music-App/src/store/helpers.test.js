import {
  capitalize,
  capitalizeWords,
  formatDateDDmmmYYYY,
  nicknameDividers,
} from './helpers';

describe('capitalize', () => {
  it('should capitalize the first letter of a string and lowercase the rest', () => {
    expect(capitalize('heLLo')).toBe('Hello');
  });

  it('should throw an error if the input is not a string', () => {
    expect(() => capitalize(123)).toThrow(
      'Invalid input: Argument must be a string'
    );
  });
});

describe('capitalizeWords', () => {
  it('should capitalize the first letter in a string', () => {
    expect(capitalizeWords('heLLo wORLd')).toBe('Hello world');
    expect(capitalizeWords('heLLowORLd')).toBe('Helloworld');
  });

  it('should replace all dividers with spaces and capitalize the next word', () => {
    nicknameDividers.forEach((divider) => {
      expect(capitalizeWords(`heLLo${divider}wORLd`)).toBe('Hello World');
    });
  });

  it('should replace all dividers with spaces and capitalize the next word, even with multiple dividers', () => {
    nicknameDividers.forEach((divider) => {
      expect(capitalizeWords(`heLLo${divider}${divider}wORLd`)).toBe(
        'Hello World'
      );
    });
  });

  it('should throw an error if the input is not a string', () => {
    expect(() => capitalizeWords(123)).toThrow(
      'Invalid input: Argument must be a string'
    );
  });

  it('should return an empty string if the input is an empty string', () => {
    expect(capitalizeWords('')).toBe('');
  });
});

describe('formatDateDDmmmYYYY', () => {
  it("should format a date string into the format 'DD MMM YYYY'", () => {
    const inputDate = '2021-09-15';
    const formattedDate = '15 Sept 2021';
    expect(formatDateDDmmmYYYY(inputDate)).toBe(formattedDate);
  });

  it('should format a date string with a custom locale', () => {
    const inputDate = '2021-09-15';
    const formattedDateUa = '15 вер. 2021 р.'; // Ukrainian format
    expect(formatDateDDmmmYYYY(inputDate, 'uk-UA')).toBe(formattedDateUa);
  });

  it('should throw an error if the input is an invalid date', () => {
    const invalidInput = 'Invalid date';
    expect(() => formatDateDDmmmYYYY(invalidInput)).toThrow();
  });
});
