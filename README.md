# WiFi\_QR\_LaTeX

This script generates nice LaTeX printouts of QR codes for your home WiFi network.
Print them out, laminate them, and hang 'em everywhere!
Of course, everything is done offline, so nobody _accidentally_ steals your WiFi password :)

## Dependencies
* [wifi-qrcode-generator](https://github.com/lakhanmankani/wifi_qrcode_generator) to create WiFi QR Codes in PNG format.
* python3
* pdflatex of course ;)

## Usage

Basically you only need to execute _run.sh_, it does everything (except for installing dependencies).

For this reason it asks you for your Wifi credentials and stores them in a file named _credentials.txt_ (within the script's directory).
If you want, you can instead supply that file yourself: The first line (only) contains the network's SSID and the second line (only) contains the respective password.
For instance, the _credentials.txt.example_ file can be renamed to _credentials.txt_ in order to generate the example PDF which you see within the repository.

## Customizing

Of course, you can edit the LaTeX template (wifi-qr.tex) for those printouts as you wish :)

## Limitations

Only supports WPA2 networks officially.

Maybe not all esoteric characters work within network names and passwords, since LaTeX could get confused e.g. by tabs. But with usual passwords, this should not be a problem.

The run script also does not clean up by itself, so some unneeded files may remain in the script's directory after execution. They also contain your WiFi credentials.
