import { defineRule, configure } from 'vee-validate';
import { required, email, min, max, confirmed } from '@vee-validate/rules';
// import { localize, setLocale } from '@vee-validate/i18n'; // Keep commented out for now
// import ja from '@vee-validate/i18n/dist/locale/ja.json'; // Keep commented out for now

// Define rules
defineRule('required', required);
defineRule('email', email);
defineRule('min', min);
defineRule('max', max);
defineRule('confirmed', confirmed);

// Custom email rule (matching the old VeeValidate v2 pattern)
defineRule('custom_email', (value) => {
  if (typeof value !== 'string' || !value) {
    // For required rule, VeeValidate expects a string message or true for valid
    // Let's return a specific message string if format is invalid, 
    // or rely on 'required' rule if value is empty.
    return 'メールアドレスの形式が正しくありません'; 
  }
  const pattern = /^\w+([-+.']\w+)*@\w+([-.]?\w+)*\.(\w+([-.]?\w+)*)+$/;
  return pattern.test(value) || 'メールアドレスの形式が正しくありません';
});

// Configure VeeValidate with a simple custom Japanese message generator
configure({
  generateMessage: (context) => {
    const fieldName = context.field;
    const params = context.rule.params; // For rules like min/max that have parameters
    const messages = {
      required: `${fieldName}は必須項目です。`,
      email: `${fieldName}の形式が正しくありません。`,
      custom_email: `${fieldName}の形式が正しくありません。`,
      min: `${fieldName}は${params && params[0] ? params[0] : '指定された'}文字以上で入力してください。`,
      max: `${fieldName}は${params && params[0] ? params[0] : '指定された'}文字以下で入力してください。`,
      confirmed: `${fieldName}が一致しません。` // Assuming a simple message for confirmed
    };
    return messages[context.rule.name] || `エラー (${context.rule.name})`; // Fallback message
  },
  validateOnInput: true,
  validateOnChange: true,
  validateOnBlur: true,
  validateOnModelUpdate: true
});

// setLocale('ja'); // Keep commented out for now

export default {};