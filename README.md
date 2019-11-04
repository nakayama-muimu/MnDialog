


概要
- js ファイル１つで済むようにする
  - css は動的に生成
- カスタマイズした色などの設定を共有できるようにする
  - 動作がわかりにくくなるか...

css-prefix
- コンストラクタで指定
  - 必須ではないが，指定の有無で動作が異なる
  - style タグの id もこれを使用
- 指定なしなら，デフォルト値 (mndlg_timestamp_*)
  - ダイアログの表示の際に動的に css を生成
- 指定ありなら，その文字列 + _ + *
  - ダイアログの表示の際に，未生成なら，生成
  - ２つ以上のインスタンスで同じものを共有したい場合は？
    - 複数ダイアログで同じ prefix を指定すると，生成済みのものが再利用される
    - 更新用のメソッドを設ける

id-prefix
  - 一意のもの (チェックする？)
  - 指定なしなら，エレメントにid付けない


 