import js.html.KeyboardEvent;
import js.lib.Object;
import js.html.TouchEvent;
import js.lib.Function;
import js.Browser.document;

@:expose
@:keep


class MnDialog{
    var divBG:js.html.DivElement;
    var divBase:js.html.DivElement;
    var divTitle:js.html.DivElement;
    var divBody:js.html.DivElement;
    var divButtons:js.html.DivElement;
    var button1:js.html.ButtonElement;
    var button2:js.html.ButtonElement;
    var button3:js.html.ButtonElement;
    var btType = "OK";
    var btLang = "en";
    var btFocused = "none";
    var keyupEnabled = false;
    var colorTitle:String = "#9999ff";
    var colorTitleText = "#ffffff";
    var colorButton:String = "#6666ff";
    var colorBase:String = "#eeeeff";
    var cssPrefix:String;
    var id:String = "";
    var width:Int;
    var height:Int;
    var maxBodyHeight:Int = 400;
    var cbButton:js.lib.Function;
    var bTouchAvailable = false;
    var bDragging = false;
    var iX:Int;
    var iY:Int;

    /**
     * Constructor
     * @param width Optional. 
     * @param height Optional.
     * @param id Optional.
     * @param cssPrefix Optional. 
     */
    public function new(width:Int = 250, height:Int = 20, id:String, cssPrefix:String){
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
        this.outputCSS(false);

        // エレメントの作成
        cssPrefix = this.cssPrefix + "_";
        // 背景
        divBG = document.createDivElement();
        divBG.className = cssPrefix + "bg";
        document.body.appendChild(divBG);
        // ウィンドウの土台
        divBase = document.createDivElement();
        divBase.className = cssPrefix + "base";
        if(this.id != ""){
            divBase.id = this.id;
        }
        divBG.appendChild(divBase);
        // ウィンドウのタイトル
        divTitle = document.createDivElement();
        divTitle.className = cssPrefix + "title";
        divTitle.textContent = "Title";
        divBase.appendChild(divTitle);
        // 表示内容
        divBody = document.createDivElement();
        divBody.textContent = "Body";
        divBody.className = cssPrefix + "body";
        divBase.appendChild(divBody);
        // 下部ボタン用の領域
        divButtons = document.createDivElement();
        divButtons.className = cssPrefix + "buttons";
        divBase.appendChild(divButtons);
        // ボタン
        button1 = document.createButtonElement();
        button1.textContent = "OK";
        button1.value = "OK";
        button1.className = cssPrefix + "button";
        button1.name = "button1";
        divButtons.appendChild(button1);
        button2 = document.createButtonElement();
        button2.textContent = "Cancel";
        button2.value = "Cancel";
        button2.className = cssPrefix + "button";
        button2.name = "button2";
        divButtons.appendChild(button2);
        button3 = document.createButtonElement();
        button3.textContent = "NO!";
        button3.value = "No";
        button3.className = cssPrefix + "button";
        button3.name = "button3";
        divButtons.appendChild(button3);
        // デフォルト表示: OK, en
        setButtonType(btType, btLang);

        // Desktop vs Mobile
        var evPress = "click";
        var evDragStart = "mousedown";
        var evDragMove = "mousemove";
        var evDragEnd = "mouseup";
        if(Reflect.hasField(js.Browser.window, "ontouchend")){
            bTouchAvailable = true;
            evPress = "touchend";
            evDragStart = "touchstart";
            evDragMove = "touchmove";
            evDragEnd = "touchend";
        }
        // ボタンの動作
        button1.addEventListener(evPress, function(){onButtonPress(button1.value);});
        button2.addEventListener(evPress, function(){onButtonPress(button2.value);});
        button3.addEventListener(evPress, function(){onButtonPress(button3.value);});
        // ドラッグ
        divTitle.addEventListener(evDragStart, startDrag);
        //divTitle.addEventListener(evDragMove, moveDrag);
        //divTitle.addEventListener(evDragEnd, endDrag);
        divBG.addEventListener(evDragMove, moveDrag);
        divBG.addEventListener(evDragEnd, endDrag);
    }

    /**
     * Set title string
     * @param text 
     */
    public function setTitle(text:String){
        if(text != null){
            divTitle.textContent = text;
        }

    }

    /**
     * Set body as text
     * @param text 
     */
    public function setBody(text:String){
        if(text != null){
            divBody.textContent = text;
        }
    }

    /**
     * Set body as html
     * @param htmlText 
     */
    public function setBodyHTML(htmlText:String){
        if(htmlText != null){
            divBody.innerHTML = htmlText;
        }
    }

    /**
     * Set colors
     * @param colorBase 
     * @param colorTitle 
     * @param colorTitleText 
     * @param colorButton Color for "hover"
     */
    public function setColor(colorBase, colorTitle, colorTitleText, colorButton){
        if(colorBase != null && colorBase != ""){
            this.colorBase = colorBase;
        }
        if(colorTitle != null && colorTitle != ""){
            this.colorTitle = colorTitle;
        }
        if(colorTitleText != null && colorTitleText != ""){
            this.colorTitleText = colorTitleText;
        }
        if(colorButton != null && colorButton != ""){
            this.colorButton = colorButton;
        }
        this.outputCSS();
    }

    /**
     * Dynamically set CSS
     * @param delete 
     */
    public function outputCSS(delete:Bool = true){
        // CSS が存在していたら，更新のために削除する
        var oCSS = document.getElementById(this.cssPrefix);
        trace(oCSS);
        if(oCSS != null){
            if(!delete){
                trace("Canceled deletion of css: ", this.cssPrefix);
                return;
            }
            document.head.removeChild(oCSS);
        }

        var cssPrefix = this.cssPrefix + "_";

        var css = '
.${cssPrefix}bg{
    display: none;
    background-color: rgba(0, 0, 0, 0.2);
    position: fixed;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
}
.${cssPrefix}base{
    position: absolute;
    left: 50%;
    top: 50%;
    width: ${this.width}px;
    min-height: ${this.height}px;
    transform: translate(-50%, -50%);
    background-color: ${colorBase};
    border: solid 2px ${colorTitle};
    border-radius: 4px;
    text-align: left;
    font-size: 0.8rem;
}
.${cssPrefix}title{
    background-color: ${colorTitle};
    color: ${colorTitleText};
    padding: 3px;
    cursor: pointer;
    user-select: none;
    -ms-user-select: none;
    -moz-user-select: none;
    -webkit-user-select: none;
}
.${cssPrefix}body{
    padding: 3px;
    height: ${this.height - 60}px;
    max-height: ${this.maxBodyHeight}px;
    overflow-y: auto;
}
.${cssPrefix}buttons{
    text-align: center;
    padding: 3px;
}
.${cssPrefix}button{
    border-style: none;
    color: ${colorTitleText};
    background-color: ${colorTitle};
    cursor: pointer;
    border-radius: 4px;
    min-width: 60px;
    min-height: 20px;
    margin: 4px;
    padding-left: 4px;
    padding-right: 4px;
}
.${cssPrefix}button:hover{
    background-color: ${colorButton};
}';
        var style = document.createStyleElement();
        style.id = this.cssPrefix;
        style.appendChild(document.createTextNode(css));
        document.head.appendChild(style);
        oCSS = document.getElementById(this.cssPrefix);
        trace(oCSS);
    }

    /**
     * Set the type of button and languagues
     *     You can set other caption strings by setButtonCaption
     * @param btType "OK" "OKCancel" "YesNo" "YesNoCancel" "None"
     * @param lang "en" "jp" "fr"
     */
    public function setButtonType(btType = "OK", lang = "en"){
        trace(btType);

        if(lang == null) lang = "en";
        btLang = lang;
        var caption;
        switch(lang){
            case "jp":
                caption = {ok:"OK", cancel:"キャンセル", yes:"はい", no:"いいえ"};
            case "fr":
                caption = {ok:"OK", cancel:"Annuler", yes:"Oui", no:"Non"};
            default:
                caption = {ok:"OK", cancel:"Cancel", yes:"Yes", no:"No"};
        }

        button2.style.display = "none";
        button3.style.display = "none";

        this.btType = btType;
        switch(btType){
            case "OK":
            button1.textContent = caption.ok;
            button1.value = "OK";
            case "OKCancel":
            button1.textContent = caption.ok;
            button1.value = "OK";
            button2.style.display = "";
            button2.textContent = caption.cancel;
            button2.value = "Cancel";
            case "YesNo":
            button1.textContent = caption.yes;
            button1.value = "Yes";
            button2.style.display = "";
            button2.textContent = caption.no;
            button2.value = "No";
            case "YesNoCancel":
            button1.textContent = caption.yes;
            button1.value = "Yes";
            button2.style.display = "";
            button2.textContent = caption.no;
            button2.value = "No";
            button3.style.display = "";
            button3.textContent = caption.cancel;
            button3.value = "Cancel";
            case "None":
            button1.style.display = "none";
            button2.style.display = "none";
            button3.style.display = "none";
        }
    }

    /**
     * Customize caption strings for each button
     * @param bt1Caption 
     * @param bt2Caption 
     * @param bt3Caption 
     */
    public function setButtonCaption(bt1Caption, bt2Caption, bt3Caption){
        if(bt1Caption != null) button1.textContent = bt1Caption;
        if(bt2Caption != null) button2.textContent = bt2Caption;
        if(bt3Caption != null) button3.textContent = bt3Caption;
    }

    /**
     * Set callback function on button press
     * @param cbFunc 
     */
    public function setButtonCallback(cbFunc:js.lib.Function){
        this.cbButton = cbFunc;
    }

    /**
     * Enable to fire button callback on keyup of Enter or Escape
     * @param bFlag 
     */
    public function enableKeyup(bFlag) {
        keyupEnabled = bFlag;
    }

    /**
     * Callback function for keyup
     * @param ev 
     */
    private function cbKeyup(ev){
        trace(ev.key, ev.target);

        // ダイアログの表示中でなければ，何もしない
        if(divBG.style.display == "none") return;

        switch(ev.key){
            case "Enter":
                // OK Cancel で Cancel にフォーカスががあったら，OK じゃダメだが...
                // 先にボタンのイベントが発火してkeyupをremoveEventListenerするから大丈夫のようだ
                if(btType == "OK" || btType == "OKCancel"){
                    hide();
                    onButtonPress("OK");
                }

            case "Esc", "Escape":
                if(btType == "OKCancel" || btType == "YesNoCancel"){
                    hide();
                    onButtonPress("Cancel");
                }
        }
    }

    /**
     * Set focus on button.
     * @param btNumber "button1" "button2" "button3" "none"(no focus)
     *     Without btNumber, set focus to previously designated button (default "none")
     */
    public function setButtonFocus(btNumber = ""){
        if(btNumber != ""){
            btFocused = btNumber;
        }else{
            btNumber = btFocused;
        }
        trace("Button focus on: " + btNumber);
        switch(btNumber){
            case "button1":
                button1.focus();
            case "button2":
                button2.focus();
            case "button3":
                button3.focus();
            default:
                btFocused = "none";
                button1.blur();
                button2.blur();
                button3.blur();
        }
    }

    

    /**
     * Show dialog
     *     Fixed position is optonal
     * @param iFixedLeft horizontal point of the center of the dialog
     * @param iFixedTop vertical point of the center of the dialog
     */
    public function show(iFixedLeft, iFixedTop) {
        if(iFixedLeft == null){
            this.divBase.style.left = "";
        }else{
            this.divBase.style.left = iFixedLeft + "px";
        }
        if(iFixedTop == null){
            this.divBase.style.top = "";
        }else{
            this.divBase.style.top = iFixedTop + "px";
        }
        if(keyupEnabled){
            js.Browser.window.addEventListener("keyup", cbKeyup);
        }

        this.divBG.style.display = "block";
        setButtonFocus();
    }

    /**
     * Hide dialog
     */
    public function hide(){
        divBG.style.display = "none";
        if(keyupEnabled){
            js.Browser.window.removeEventListener("keyup", cbKeyup);
        }
    }

    /**
     * Callback for buttons
     * @param button_value 
     */
    public function onButtonPress(button_value){
        //divBG.style.display = "none";
        hide();
        if(cbButton != null) cbButton.call(this, button_value);
    }


    /**
     * Callback function for drag
     * @param ev 
     */
    public function startDrag(ev){
        bDragging = true;
        // 座標を記録
        var evt = ev;
        if(bTouchAvailable){
            evt = cast ev.changedTouches[0];
        }
        //iX = evt.pageX - divTitle.offsetLeft;
        //iY = evt.pageY - divTitle.offsetTop;
        iX = evt.pageX;
        iY = evt.pageY;
        //trace(evt.pageX, divTitle.offsetLeft, iX);
    }

    /**
     * Callback function for drag
     * @param ev 
     */
    public function moveDrag(ev) {
        ev.preventDefault();
        if(!bDragging) return;
        // 座標を取得し，差分を移動
        var evt = ev;
        if(bTouchAvailable){
            evt = cast ev.changedTouches[0];
        }
        //trace(evt.pageX, divTitle.offsetLeft, iX);
        //divBase.style.left = evt.pageX - iX + "px";
        //divBase.style.top = evt.pageY - iY + "px";
        divBase.style.left = divBase.offsetLeft + evt.pageX - iX + "px";
        divBase.style.top = divBase.offsetTop + evt.pageY - iY + "px";
        trace(iX - evt.pageX, divBase.style.left);
        iX = evt.pageX;
        iY = evt.pageY;
        
    }

    /**
     * Callback function for drag
     */
    public function endDrag() {
        bDragging = false;
        // 座標を取得し，差分を移動
        
    }

}