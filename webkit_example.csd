<CsoundSyntheizer>
<CsLicense>
Message From Another Planet (v4)  (Spring 1999, Fall 2017, Fall 2021)

Composed By Jacob Joaquin
Modified by Michael Gogins

To search for extraterrestrial intelligence from your home computer visit
https://setiathome.berkeley.edu/
</CsLicense>
<CsOptions;
-m195 -odac
</CsOptions>
<CsInstruments>

alwayson "Browser" 

sr              =           48000
ksmps           =           128
nchnls          =           2

alwayson "controls"
alwayson "reverb"

gasendL init 0
gasendR init 0

gk2_spread      init 1.0125
gk2_bass_gain   init 0.005
chnset i(gk2_spread), "gk2_spread" 
chnset i(gk2_bass_gain), "gk2_bass_gain" 

                instr       controls
gk2_spread      chnget      "gk2_spread"
gk2_bass_gain   chnget      "gk2_bass_gain"
gk_reverb_delay chnget      "gk_reverb_delay"
gk_reverb_hipass chnget     "gk_reverb_hipass"
gk_master_level chnget      "gk_master_level"
                endin
                instr       Spreader
    kpch        =           cpspch(p5)
    imult       =           ((p6+1) / p6) * .5
    iseed       =           (rnd(100)+100)/200
    k2          expseg      .0625, 15, .0625, 113, 3.75, 113, .03125, 15, .0625
    k3          linseg      1, 240, 1, 16, 0
    k1          phasor      p7 * k2
    k1          tablei      256 * k1 , 100, 0, 0, 1
    krand       randi       30000, p7 * 5, iseed
    krand       =           (krand + 30000) / 60000
    kcps        =           kpch * p6 * gk2_spread
    kamp        =           p4 * imult * k1 * k3 * pow(kcps, -gk2_bass_gain)
    a1          poscil      kamp, kcps, 1
    aoutleft    =           a1 * sqrt(krand)
    aoutright   =           a1 * (sqrt(1-krand))
    gasendL     =           gasendL + aoutleft
    gasendR     =           gasendR + aoutright
                prints      "Spreader: gk2_spread: %12.4f  kcps: %12.4f  kamp: %12.4f\n", 1, gk2_spread, kcps, kamp
                endin

gk_reverb_delay init .89
gk_reverb_hipass init 12000
gk_master_level init -6
chnset i(gk_reverb_delay), "gk_reverb_delay" 
chnset i(gk_reverb_hipass), "gk_reverb_hipass" 
chnset i(gk_master_level), "gk_master_level" 
                instr       reverb
aL, aR          reverbsc    gasendL,gasendR,gk_reverb_delay,gk_reverb_hipass
kgain           =           ampdb(gk_master_level)
                outs        aL * kgain, aR * kgain
                clear       gasendL, gasendR
                endin

instr Browser

gS_html init {{
<!DOCTYPE html>
<html>
<head>
    <title>Message from Another Planet version 3</title>
    <style type="text/css">
    input[type='range'] {
        -webkit-appearance: none;
        box-shadow: inset 0 0 5px #333;
        background-color: gray;
        height: 10px;
        width: 100%;
        vertical-align: middle;
    }
    input[type=range]::-webkit-slider-thumb {
        -webkit-appearance: none;
        border: none;
        height: 16px;
        width: 16px;
        border-radius: 50%;
        box-shadow: inset 0 0 7px #234;
        background: chartreuse;
        margin-top: -4px;
        border-radius: 10px;
    }
    table td {
        border-width: 2px;
        padding: 8px;
        border-style: solid;
        border-color: transparent;
        color:yellow;
        background-color: teal;
        font-family: sans-serif
    }
    table th {
        border-width: 2px;
        padding: 8px;
        border-style: solid;
        border-color: transparent;
        color:white;
        background-color:teal;
         font-family: sans-serif
   }
    textarea {
        border-width: 2px;
        padding: 8px;
        border-style: solid;
        border-color: transparent;
        color:chartreuse;
        background-color:black;
        font-family: 'Courier', sans-serif
    }
    h1 {
    margin: 1em 0 0.5em 0;
    color: #343434;
    font-weight: normal;
    font-family: 'Ultra', sans-serif;   
    font-size: 36px;
    line-height: 42px;
    text-transform: uppercase;
    }
    h2 {
        margin: 1em 0 0.5em 0;
        color: #343434;
        font-weight: normal;
        font-size: 30px;
        line-height: 40px;
        font-family: 'Orienta', sans-serif;
    }    
        h3 {
        margin: 1em 0 0.5em 0;
        color: #343434;
        font-weight: normal;
        font-size:24px;
        line-height: 30px;
        font-family: 'Orienta', sans-serif;
    }    
    </style>
</head>
<body style="background-color:CadetBlue">
    <h1>Message from Another Planet, version 4</h1>
    <h3>Adapted for Csound with the WebKit opcodes by Michael Gogins, from "Message from Another Planet" by Jacob Joaquin</h3>
    <form id='persist'>
    <table>
    <col width="2*">
    <col width="5*">
    <col width="100px">
    <tr>
    <td>
    <label for=gk2_spread>Frequency spread factor</label>
    <td>
    <input class=persistent-element type=range min=0 max=4 value=1 id=gk2_spread step=.001>
    <td>
    <output for=gk2_spread id=gk2_spread_output>1</output>
    </tr>
    <tr>
    <td>
    <label for=gk2_bass_gain>Bass emphasis factor</label>
    <td>
    <input class=persistent-element type=range min=0.0001 max=1 value=.005 id=gk2_bass_gain step=.001>
    <td>
    <output for=gk2_bass_gain id=gk2_bass_gain_output>.005</output>
    </tr>
    <tr>
    <td>
    <label for=gk_reverb_delay>Reverb delay feedback</label>
    <td>
    <input class=persistent-element type=range min=0 max=1 value=.89 id=gk_reverb_delay step=.001>
    <td>
    <output for=gk_reverb_delay id=gk_reverb_delay_output>.89</output>
    </tr>
    <tr>
    <td>
    <label for=gk_reverb_hipass>Reverb highpass cutoff (Hz)</label>
    <td>
    <input class=persistent-element type=range min=0 max=20000 value=12000 id=gk_reverb_hipass step=.001>
    <td>
    <output for=gk_reverb_hipass id=gk_reverb_hipass_output>12000</output>
    </tr>
    <tr>
    <td>
    <label for=gk_master_level>Master output level (dB)</label>
    <td>
    <input class=persistent-element type=range min=-40 max=40 value=-6 id=gk_master_level step=.001>
    <td>
    <output for=gk_master_level id=gk_master_level_output>-6</output>
    </tr>
    </table>
    <p>
     <input type="button" id='save' value="Save" />
    <input type="button" id='restore' value="Restore" />
    </form>   
    <p>
</script>
<script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
<script src="csound.js"></script>
<script>   
    $(document).ready(function() {
    var csound = new Csound("http://localhost:8383");
    csound.Message("Hello, World! -- from message.html displayed by the WebKit opcodes\\n");
    $('input').on('input', async function(event) {
        var slider_value = parseFloat(event.target.value);
        csound.SetControlChannel(event.target.id, slider_value);
        var output_selector = '#' + event.target.id + '_output';
        $(output_selector).val(slider_value);
    });
    $('#save').on('click', function() {
        $('.persistent-element').each(function() {
            localStorage.setItem(this.id, this.value);
        });
    });
    $('#restore').on('click', async function() {
        $('.persistent-element').each(function() {
            this.value = localStorage.getItem(this.id);
            csound.SetControlChannel(this.id, parseFloat(this.value));
            var output_selector = '#' + this.id + '_output';
            $(output_selector).val(this.value);
        });
    });
});
</script>
</body>
</html>
}}

gi_browser webkit_create 8383, 1
webkit_open_uri gi_browser, "Csound Help", "https://csound.com/docs/manual/indexframes.html", 900, 600
webkit_open_uri gi_browser, "WebKit Opcodes HTML5 Capabilities", "https://html5test.com", 900, 600
S_pwd pwd
S_base_uri sprintf "file://%s/", S_pwd
prints S_base_uri
webkit_open_html gi_browser, "Message", gS_html, S_base_uri, 900, 650
webkit_run_javascript gi_browser, "window.document.body.style='background-color:Yellow;'";
endin

instr 3
webkit_run_javascript gi_browser, "window.document.body.style='background-color:Black;'";
endin

</CsInstruments>
<CsScore>
f 0 [10 * 60]
; p1   p2   p3     p4      p5      p6         p7
f 1    0    65537  10      1
f 100  0    256  -7      0       16         1    240    0
t 0    60
i 2    0    256    3000    6.00    1          1.24    
i 2    0    .      .       .       1.0666     1.23    
i 2    0    .      .       .       1.125      1.22    
i 2    0    .      .       .       1.14285    1.21    
i 2    0    .      .       .       1.23076    1.20    
i 2    0    .      .       .       1.28571    1.19    
i 2    0    .      .       .       1.333      1.18    
i 2    0    .      .       .       1.4545     1.17    
i 2    0    .      .       .       1.5        1.16    
i 2    0    .      .       .       1.6        1.15    
i 2    0    .      .       .       1.777      1.14    
i 2    0    .      .       .       1.8        1.13    
i 2    0    .      .       .       2          1.12    
i 2    0    .      .       .       2.25       1.10    
i 2    0    .      .       .       2.28571    1.09    
i 2    0    .      .       .       2.666      1.08    
i 2    0    .      .       .       3          1.07    
i 2    0    .      .       .       3.2        1.06    
i 2    0    .      .       .       4          1.05    
i 2    0    .      .       .       4.5        1.04    
i 2    0    .      .       .       5.333      1.03    
i 2    0    .      .       .       8          1.02    
i 2    0    .      1000    .       9          1.01    
i 2    0    .      500     .       16         1.00    
i 3   10    1
</CsScore>
</CsoundSynthesizer>
