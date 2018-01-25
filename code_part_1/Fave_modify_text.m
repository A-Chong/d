
function[b] =Fave_modify_text(a, name)
vowels_and_silence = {'aa','ae','ah','ao','aw','axl','ay','eh', 'ey', 'er','ih','iy','ow','uw', 'uh',...
    'silence','sil', 'IGNORE', 'nonspeech', 'sp', '', 'disf', 'h'};

for i = 1:length(a)
    word = a(i).text;
    
    % if it's not silence or vowel, that is it's a word or a consonant
    if ~any(ismember(vowels_and_silence, word)) 
        a(i).text = upper(a(i).text);
        
    % if it's either silence or a vowel
    else                                        
        switch word
            case 'h'
                a(i).text = 'HH';
            case ''
                a(i).text = 'sp';                               
            case 'sp'
                a(i).text = 'sp';              
            case 'disf'
                a(i).text = 'sp';
            case 'nonspeech'
                a(i).text = 'sp';
            case 'silence'
                a(i).text = 'sp';
            case 'sil'
                a(i).text = 'sp';
            case 'SIL'
                a(i).text = 'sp';                
            case 'IGNORE'
                a(i).text = 'sp';           
            case 'iy'
                a(i).text = 'IY1';
            case 'ih'
                a(i).text = 'IH1';
            case 'aa'
                a(i).text = 'AA1';
            case 'ae'
                a(i).text = 'AE1';
            case 'ah'
                a(i).text = 'AH1';
            case 'ao'
                a(i).text = 'AW1';
            case 'aw'
                a(i).text = 'AW1';
            case 'axl'
                a(i).text = 'AH1';
            case 'ay'
                a(i).text = 'AY1';
            case 'eh'
                a(i).text = 'EH1';
            case 'ey'
                a(i).text = 'EY1';
            case 'er'
                a(i).text = 'ER1';
            case 'ow'
                a(i).text = 'OW1';
            case 'uw'
                a(i).text = 'UW1';
            case 'uh'
                if strcmp(name(2:4), 'phn')
                  a(i).text = 'UH0';
                else
                  a(i).text = upper(a(i).text);
                end;
            otherwise
                fprintf([':-(  row: '   num2str(i)]);
        end;
    end;    
end;


b = a;


end