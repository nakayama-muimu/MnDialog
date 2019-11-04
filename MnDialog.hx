import js.Browser.document;

@:expose
@:keep


class MnDialog{
    var divBG:js.html.DivElement;
    var divBase:js.html.DivElement;
    var divTitle:js.html.DivElement;
    var divBody:js.html.DivElement;
    var divButtons:js.html.DivElement;
    var colorTitle:String = "#9999ff";
    var colorButton:String = "#6666ff";
    var colorBase:String = "#eeeeff";
    var cssPrefix:String;
    var id:String = '';
    var width:Int;
    var height:Int;

    public function new(width:Int = 250, height:Int = 150, id:String, cssPrefix:String){
        // 引数の処理
        // オブジェクトのid
        if(id != null){
            this.id = id;
        }
        // cssのプレフィックス（styleタグのidとしても使用）
        if(cssPrefix != null){
            this.cssPrefix = cssPrefix;
        }else{
            this.cssPrefix = "mndlg_" + (Date.now()).getTime();
        }
        this.width = width;
        this.height = height;

        // cssの出力
        this.outputCSS();

        // エレメントの作成
        cssPrefix = this.cssPrefix + "_";
        // 背景
        divBG = document.createDivElement();
        /*
        divBG.style.display = "none";
        divBG.style.backgroundColor = "rgba(0, 0, 0, 0.5)";
        divBG.style.position = "fixed";
        divBG.style.left = "0";
        divBG.style.top = "0";
        divBG.style.width = "100%";
        divBG.style.height = "100%";
        */
        divBG.className = cssPrefix + "bg";
        document.body.appendChild(divBG);

        divBase = document.createDivElement();
        /*
        divBase.style.position = "absolute";
        divBase.style.left = "50%";
        divBase.style.top = "50%";
        divBase.style.width = this.width + "px";
        divBase.style.minHeight = this.height + "px";
        divBase.style.transform = "translate(-50%, -50%)";
        divBase.style.backgroundColor = colorBase;
        divBase.style.border = "solid 2px " + colorTitle;
        divBase.style.borderRadius = "3px";
        */
        divBase.className = cssPrefix + "base";
        if(this.id != ""){
            divBase.id = this.id;
        }
        divBG.appendChild(divBase);

        divTitle = document.createDivElement();
        //divTitle.style.backgroundColor = colorTitle;
        //divTitle.style.padding = "3px";
        divTitle.className = cssPrefix + "title";
        divTitle.textContent = "Title";
        divBase.appendChild(divTitle);

        divBody = document.createDivElement();
        // 世を忍ぶ仮の表示内容
        divBody.innerHTML = "Body<br>
        <ul>
        <li>aaa</li><li>bbb</li><li>ccc</li></ul>";
        //divBody.style.padding = "3px";
        divBody.className = cssPrefix + "body";
        divBase.appendChild(divBody);

        divButtons = document.createDivElement();
        divButtons.className = cssPrefix + "buttons";
        divBase.appendChild(divButtons);

        var bt1 = document.createButtonElement();
        bt1.textContent = "Button 1";
        //bt1.style.backgroundColor = colorButton;
        bt1.className = cssPrefix + "button";
        divButtons.appendChild(bt1);

        // ボタンの動作
        var evAction = "click";
        if(Reflect.hasField(js.Browser.window, "ontouchend")) evAction = "touchend";
        bt1.addEventListener(evAction, this.cbButton1);

    }

    public function outputCSS(){
        // CSS が存在していたら，更新のために削除する
        var oCSS = document.getElementById(this.cssPrefix);
        if(oCSS != null){
            document.head.removeChild(oCSS);
        }

        var cssPrefix = this.cssPrefix + "_";
        /*
        if(this.id != ""){
            cssPrefix = "mndlg_" + this.id + "_";
        }else{
            cssPrefix = "mndlg_" + (Date.now()).getTime() + "_";
        }
        */
        var css = "." + cssPrefix + "bg{
    display: none;
    background-color: rgba(0, 0, 0, 0.2);
    position: fixed;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
}
." + cssPrefix + "base{
    position: absolute;
    left: 50%;
    top: 50%;
    width: " + this.width + "px;
    min-height: " + this.height + "px;
    transform: translate(-50%, -50%);
    background-color: " + colorBase + ";
    border: solid 2px " + colorTitle + ";
    border-radius: 3px;
}
." + cssPrefix + "title{
    background-color: " + colorTitle + ";
    padding: 3px;
}
." + cssPrefix + "body{
    padding: 3px;
}
." + cssPrefix + "buttons{
    text-align: center;
    padding: 3px;
}
." + cssPrefix + "button{
    border-style: none;
    background-color: " + colorTitle + ";
    cursor: pointer;
}
." + cssPrefix + "button:hover{
    background-color: " + colorButton + ";
}";
        var style = document.createStyleElement();
        style.id = this.cssPrefix;
        style.appendChild(document.createTextNode(css));
        document.head.appendChild(style);
    }
    public function show(){
        divBG.style.display = "block";
    }

    public function cbButton1(){
        divBG.style.display = "none";
    }

}