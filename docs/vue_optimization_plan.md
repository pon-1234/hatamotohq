# Vue コンポーネント最適化計画

## 現状分析サマリー

### 技術スタック
- Vue 2.6.12（2019年リリース、現在はEOL）
- Vuex 3.5.1（Vue 2用）
- 関連ライブラリ：Bootstrap-Vue、VeeValidate v2、CKEditor Vue 2

### 主な問題点
1. **巨大なコンポーネント**（900行以上）
2. **jQuery との混在**（アンチパターン）
3. **Vue 3 移行の多数のブロッカー**
4. **コンポーネントの再利用性の低さ**
5. **テストの欠如**

## フェーズ1: 即時改善（1-2週間）

### 1.1 巨大コンポーネントの分割

#### 対象コンポーネント
- `RichMenuImageEditor.vue` (943行) → 5-6個の小コンポーネントに分割
- `MessageEditorCarousel.vue` (641行) → 3-4個の小コンポーネントに分割
- `AutoResponseEditor.vue` (512行) → 3-4個の小コンポーネントに分割

#### 分割方針
```javascript
// Before: RichMenuImageEditor.vue
<template>
  <div class="rich-menu-editor">
    <!-- 900行以上のテンプレート -->
  </div>
</template>

// After: 
// RichMenuImageEditor.vue (親コンポーネント)
<template>
  <div class="rich-menu-editor">
    <RichMenuCanvas :menu="richMenu" @update="updateMenu" />
    <RichMenuAreaList :areas="richMenu.areas" @edit="editArea" />
    <RichMenuActionEditor v-if="selectedArea" :area="selectedArea" />
    <RichMenuPreview :menu="richMenu" />
  </div>
</template>
```

### 1.2 jQuery 依存の除去

#### 対象箇所
```javascript
// Before
$('.preview-area.active').removeClass('active')

// After (Vue way)
this.activeAreaId = null
// テンプレート側で :class="{ active: area.id === activeAreaId }"
```

### 1.3 共通コンポーネントの抽出

#### 作成する共通コンポーネント
- `BaseTable.vue` - テーブル表示の共通化
- `BaseModal.vue` - モーダルダイアログの共通化
- `BaseForm.vue` - フォームの共通化
- `ImageUploader.vue` - 画像アップロードの共通化
- `DateTimePicker.vue` - 日時選択の共通化

## フェーズ2: Vue 2.7 への移行（2-3週間）

### 2.1 Vue 2.7 アップグレード
```json
{
  "dependencies": {
    "vue": "^2.7.16",
    "vue-template-compiler": "^2.7.16"
  }
}
```

### 2.2 Composition API の段階的導入

#### 新規コンポーネントでの使用例
```javascript
// composables/useLineMessage.js
import { ref, computed } from 'vue'

export function useLineMessage() {
  const message = ref('')
  const messageType = ref('text')
  
  const isValid = computed(() => {
    return message.value.length > 0 && message.value.length <= 2000
  })
  
  function sendMessage() {
    // 送信ロジック
  }
  
  return {
    message,
    messageType,
    isValid,
    sendMessage
  }
}
```

### 2.3 TypeScript の導入準備
- 型定義ファイルの追加
- tsconfig.json の設定
- 新規コンポーネントから TypeScript 化

## フェーズ3: 状態管理の最適化（2週間）

### 3.1 Vuex モジュールの整理
- 未使用の state/mutations/actions の削除
- 名前空間の整理
- TypeScript 型定義の追加

### 3.2 Pinia への移行準備
```javascript
// stores/channel.js (Pinia style)
import { defineStore } from 'pinia'

export const useChannelStore = defineStore('channel', {
  state: () => ({
    channels: [],
    activeChannel: null
  }),
  
  getters: {
    unreadCount: (state) => {
      return state.channels.reduce((sum, ch) => sum + ch.unreadCount, 0)
    }
  },
  
  actions: {
    async fetchChannels() {
      const response = await api.getChannels()
      this.channels = response.data
    }
  }
})
```

## フェーズ4: Vue 3 移行準備（3-4週間）

### 4.1 依存ライブラリの更新
- Bootstrap-Vue → Bootstrap 5 + カスタムコンポーネント
- VeeValidate v2 → v4
- CKEditor Vue 2 → Vue 3 対応版

### 4.2 破壊的変更の対応
- `.sync` 修飾子 → `v-model` with computed
- グローバルコンポーネント登録 → ローカル登録
- filters → computed properties or methods

### 4.3 移行スクリプトの作成
```bash
# .sync modifier を v-model に変換
find . -name "*.vue" -exec sed -i 's/:value\.sync="/:model-value="@update:model-value="/g' {} \;
```

## フェーズ5: テストの追加（継続的）

### 5.1 単体テスト
```javascript
// RichMenuCanvas.spec.js
import { mount } from '@vue/test-utils'
import RichMenuCanvas from '@/components/RichMenuCanvas.vue'

describe('RichMenuCanvas', () => {
  it('renders menu areas correctly', () => {
    const wrapper = mount(RichMenuCanvas, {
      props: {
        menu: {
          areas: [
            { id: 1, x: 0, y: 0, width: 100, height: 100 }
          ]
        }
      }
    })
    
    expect(wrapper.findAll('.menu-area')).toHaveLength(1)
  })
})
```

### 5.2 E2E テスト
- Cypress または Playwright の導入
- 主要なユーザーフローのテスト作成

## 推奨される実施順序

1. **即時実施**（並行可能）
   - jQuery 依存の除去
   - 巨大コンポーネントの分割
   - 共通コンポーネントの抽出

2. **短期（1ヶ月以内）**
   - Vue 2.7 へのアップグレード
   - Composition API の導入開始
   - 基本的な単体テストの追加

3. **中期（3ヶ月以内）**
   - TypeScript の段階的導入
   - Vuex から Pinia への移行検討
   - Vue 3 移行の準備開始

4. **長期（6ヶ月以内）**
   - Vue 3 への完全移行
   - 全コンポーネントの TypeScript 化
   - 包括的なテストカバレッジの達成

## 期待される成果

1. **パフォーマンス向上**
   - 初期ロード時間の短縮（20-30%）
   - レンダリング性能の改善

2. **開発効率の向上**
   - コンポーネントの再利用性向上
   - バグの早期発見（テストによる）
   - 型安全性の確保（TypeScript）

3. **保守性の向上**
   - コードの可読性向上
   - 依存関係の明確化
   - 最新エコシステムへの対応

## リスクと対策

### リスク
1. 既存機能の破壊
2. 移行期間中の開発速度低下
3. チーム学習コスト

### 対策
1. 段階的移行とテストの充実
2. 新機能は新しい方式で開発
3. チーム勉強会の実施

## まとめ

この最適化計画により、技術的負債を解消しながら、モダンなVueアプリケーションへと進化させることができます。段階的なアプローチにより、リスクを最小限に抑えながら、着実に改善を進めることが可能です。