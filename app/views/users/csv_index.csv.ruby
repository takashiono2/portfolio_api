require 'csv'
CSV.generate(encoding: Encoding::SJIS, row_sep: "\r\n", force_quotes: true) do |csv|#UTF-8をエクセルで文字化けしない様にSJISにエンコード
  column_names = ["名前","所属","クラス","階級","参加内容"]
  csv << column_names
    @at1.each_with_index do |rep,i|
        t0 = User.find(@at1[i]).name if @at1[i].present?
        t1 = User.find(@at1[i]).affiliation if @at1[i].present?
        t2 = User.find(@at1[i]).department if @at1[i].present?
        t3 = User.find(@at1[i]).status if @at1[i].present?
    column_values = [t0,t1,t2,t3,"出場選手"]
    csv << column_values
    end
    
    @at2.each_with_index do |rep,i|
        t4 = User.find(@at2[i]).name if @at2[i].present?
        t5 = User.find(@at2[i]).affiliation if @at2[i].present?
    column_values = [t4,t5,"","","会場スタッフ"]
    csv << column_values
    end
    column_values = ["合計 #{@rep_attendance.count}人"]
    csv << column_values
end