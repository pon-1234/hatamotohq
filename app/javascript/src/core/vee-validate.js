import { defineRule, configure } from 'vee-validate';
import { required, email, min, max, confirmed } from '@vee-validate/rules';
import { localize, setLocale } from '@vee-validate/i18n';
import ja from '@vee-validate/i18n/dist/locale/ja.json';

// Define rules
defineRule('required', required);
defineRule('email', email);
defineRule('min', min);
defineRule('max', max);
defineRule('confirmed', confirmed);

// Custom email rule (matching the old VeeValidate v2 pattern)
defineRule('custom_email', (value) => {
  const pattern = /^\w+([-+.']\w+)*@\w+([-.]?\w+)*\.(\w+([-.]?\w+)*)+$/;
  return pattern.test(value) || 'メールアドレスの形式が正しくありません';
});

// Configure VeeValidate
configure({
  generateMessage: localize({
    ja: {
      ...ja,
      messages: {
        ...ja.messages,
        required: '{field}は必須項目です',
        email: '{field}の形式が正しくありません',
        min: '{field}は{length}文字以上で入力してください',
        max: '{field}は{length}文字以下で入力してください',
        confirmed: '{field}が一致しません'
      }
    }
  }),
  validateOnInput: true,
  validateOnChange: true,
  validateOnBlur: true,
  validateOnModelUpdate: true
});

// Set default locale
setLocale('ja');

export default {};