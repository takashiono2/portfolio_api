const VueLoaderPlugin = require('vue-loader/lib/plugin');

module.exports = {
  devtool: 'inline-source-map', //デバッグに必要
  mode: 'development', // Webpack4では必須
  entry: {
    webpack: './src/javascripts/entry.js' //Keyがファイル名になる
  },
  output: {
    // /app/assets以下に出力（フルパスで記述）
    // ここを書き換え
    path: '/home/vagrant/portfolio_api/kinataiA/app/assets/javascripts',
    filename: '[name].js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      },
      {
        test: /\.vue$/,
        loader: 'vue-loader'
      },
      {
        test: /\.css$/,
        use: ['vue-style-loader', 'css-loader'] // css-loader -> vue-style-loaderの順で通していく
      },
      {
        test: /\.scss$/,
        use: [
          'vue-style-loader',
          'css-loader',
          {
            loader: 'sass-loader',
          },
        ],
      }
    ]
  },
  resolve: {
    // import './foo.vue' の代わりに import './foo' と書けるようになる(拡張子省略)
    extensions: ['.js', '.vue'],
    alias: {
      // vue-template-compilerに読ませてコンパイルするために必要
      vue$: 'vue/dist/vue.esm.js',
    },
  },
  plugins: [
    new VueLoaderPlugin()
  ],
  // jQueryはRails側で用意するか、CDNを使用
  // (CoffeeScriptからjQueryを呼び出す可能性を想定)
  // 記事内ではjQueryを使用していない。読み込まなくてもエラーにならない。
  externals: {
    jquery: 'jQuery'
  }
}