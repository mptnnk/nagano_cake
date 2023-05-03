class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  # 管理者トップページ（注文履歴一覧）
  def top
    @orders = Order.all.order(created_at: ASC).page(params[:page]).per(10)
  end
  # 注文日が若い順に並び替えてみるメソッドを追加してみた
  
  # 課題の画面設計では管理者トップページは注文履歴一覧だったけど、模範回答では「今日の注文件数」だった。
  # topアクションの処理内容は@count = Order.ordered_today.countだった。
  # ordered_todayはOrderモデルでscopeで定義されており、「今日のはじまりから終わりまでのcreated_atをwhere」という内容

  def search
    # view（application.html.erb）のform_tagで
    @model = params['search']['model']
    # 選択したmodelの値を@modelに代入
    @content = params['search']['content']
    # 入力した検索ワードを@contentに代入
    @method = params['search']['method']
    # 選択した検索方法を@methodに代入
    @result = search_for(@model, @content, @method)
  end
  
  
  private

  def search_for(model, content, method)
  # contentはフォームに入力した文字列の値
    if model == 'customer'
      if method == 'forward'
      # 検索方法（method）に代入されたのが「forward」だったら
        Customer.where(
          'last_name LIKE ? OR first_name LIKE? OR last_name_kana LIKE? OR first_name_kana LIKE?',
          "#{content}%", "#{content}%", "#{content}%", "#{content}%"
        )
        # where + LIKE ? であいまい検索、％は任意の0文字以上の文字列を表すワイルドカード（_は任意の1文字のワイルドカード）
        # ％がcontentの最後についているので、前方が一致して後方に0文字以上の不確定要素がある場合を検索している
      elsif method == 'backward'
        Customer.where(
          'last_name LIKE ? OR first_name LIKE? OR last_name_kana LIKE? OR first_name_kana LIKE?',
          "%#{content}", "%#{content}", "%#{content}", "%#{content}"
        )
      elsif method == 'perfect'
        Customer.where(
          'last_name = ? OR first_name = ? OR last_name_kana = ? OR first_name_kana = ?',
          content, content, content, content
        )
      else # partialのとき。partialは部分一致
        Customer.where(
          'last_name LIKE ? OR first_name LIKE? OR last_name_kana LIKE? OR first_name_kana LIKE?',
          "%#{content}%", "%#{content}%", "%#{content}%", "%#{content}%"
        )
      end
    elsif model == 'item'
      if method == 'forward'
        Item.where('name LIKE ?', content + '%').includes(:genre)
        # includesによってgenreテーブルの情報も読んでいる
      elsif method == 'backward'
        Item.where('name LIKE ?', '%' + content).includes(:genre)
      elsif method == 'perfect'
        Item.where(name: content).includes(:genre)
      else # partial
        Item.where('name LIKE ?', '%' + content + '%').includes(:genre)
      end
    else
      [] # 空配列を返す。検索ヒットしなかったらエラーになるのを回避するためかな？
    end
  end
end