%% Copy of i_3_grid_sanity_check_phones_in_word(word, phones, varargin)

%%
function[match] = dictionary(word, phones, varargin)


if length(varargin) > 0;
    wrd = varargin{1}; end;
if length(varargin) > 1;
    phn = varargin{2}; end;

match = 'mispelled';
switch word
    case ''
        if strcmp(word, '') & (strcmp(phones,'')|strcmp(phones,'IGNORE')|strcmp(phones,'sil'));
            match = 'correct';  end;        
    case 'and'
        if   strcmp(word, 'and') & (strcmp(phones,'aen')|strcmp(phones,'aend')|strcmp(phones,'axn'));
            match = 'correct';  end;
    case 'back'
        if strcmp(word, 'back') & (strcmp(phones,'baek'));
            match = 'correct';  end;
    case 'big'
        if strcmp(word, 'big') & (strcmp(phones,'bihg')|strcmp(phones,''));
            match = 'correct';  end;
    case 'blue'
        if strcmp(word, 'blue') & (strcmp(phones,'bluw')|strcmp(phones,''));
            match = 'correct';  end;
    case 'cad'
        if strcmp(word, 'cad') & (strcmp(phones,'kaed')|strcmp(phones,''));
            match = 'correct';  end;
    case 'cat'
        if strcmp(word, 'cat') & (strcmp(phones,'kaet')|strcmp(phones,''));
            match = 'correct';  end;
    case 'circle'
        if strcmp(word, 'circle') & (strcmp(phones,'serkaxl')|strcmp(phones,''));
            match = 'correct';  end;
    case 'down'
        if strcmp(word, 'down') & (strcmp(phones,'dawn')|strcmp(phones,'dawnah')|strcmp(phones,''));  
            match = 'correct';  end;
    case 'filled'
        if strcmp(word, 'filled') & (strcmp(phones,'fihld')|strcmp(phones,''));
            match = 'correct';  end;
    case 'from'
        if strcmp(word, 'from') & (strcmp(phones,'frahm'));
            match = 'correct';  end;
    case 'green'
        if strcmp(word, 'green') & (strcmp(phones,'griyn')|strcmp(phones,'griynah')|strcmp(phones,''));
            match = 'correct';  end;
    case 'hicep'
        if strcmp(word, 'hicep') & (strcmp(phones,'haysehp')|strcmp(phones,'')|strcmp(phones,''));
            match = 'correct';  end;
    case 'kvee'
        if strcmp(word, 'kvee') & (strcmp(phones,'kihviy')|strcmp(phones,'keyviy')|strcmp(phones,'kayviy')|strcmp(phones,'kiyviy')|strcmp(phones,'kuhviy')|strcmp(phones,''));
            match = 'correct';  end;
    case 'large'
        if strcmp(word, 'large') & (strcmp(phones,'laarjh')|strcmp(phones,''));
            match = 'correct';  end;
    case 'laughter'
        if strcmp(word, 'laughter') & (strcmp(phones,'IGNORE'));
            match = 'correct';  end;
    case 'left'
        if strcmp(word, 'left') & (strcmp(phones,'lehft')|strcmp(phones,'lehf')|strcmp(phones,''));
            match = 'correct';  end;
    case 'little'
        if strcmp(word, 'little') & (strcmp(phones,'lihtaxl')|strcmp(phones,''));
            match = 'correct';  end;
    case 'near'
        if strcmp(word, 'near') & (strcmp(phones,'nihr')|strcmp(phones,''));
            match = 'correct';  end;
    case 'no'
        if strcmp(word, 'no') & (strcmp(phones,'now'));
            match = 'correct';  end;
    case 'nonspeech'
        if strcmp(word, 'nonspeech') & (strcmp(phones,'IGNORE')|strcmp(phones,''));
            match = 'correct';  end;
    case 'not'
        if strcmp(word, 'not') & (strcmp(phones,'naat'));
            match = 'correct';  end;
    case 'oh'
        if strcmp(word, 'oh') & (strcmp(phones,'ow'));
            match = 'correct';  end;
    case 'okay'
        if strcmp(word, 'okay') & (strcmp(phones,'owkey')|strcmp(phones,'key')|strcmp(phones,'ahkey')|strcmp(phones,'hey')|strcmp(phones,''));
            match = 'correct';  end;
    case 'or'
        if strcmp(word, 'or') & (strcmp(phones,'owr')|strcmp(phones,'er'));
            match = 'correct';  end;
    case 'qeed'
        if strcmp(word, 'qeed') & (strcmp(phones,'kiyd')|strcmp(phones,'kwiyd')|strcmp(phones,''));
            match = 'correct';  end;
    case 'qeet'
        if strcmp(word, 'qeet') & (strcmp(phones,'kiyt')|strcmp(phones,'kwiyt')|strcmp(phones,''));
            match = 'correct';  end;
    case 'red'
        if strcmp(word, 'red') & (strcmp(phones,'rehd')|strcmp(phones,''));
            match = 'correct';  end;
%     case 'reduced'
%         if strcmp(word, 'reduced') & (strcmp(phones,'IGNORE'));
%             match = 'correct';  end;
    case 'repeat'
        if strcmp(word, 'repeat') & (strcmp(phones,'rihpiyt'));
            match = 'correct';  end;
    case 'right'
        if strcmp(word, 'right') & (strcmp(phones,'rayt')|strcmp(phones,''));
            match = 'correct';  end;
    case 'sbot'
        if strcmp(word, 'sbot') & (strcmp(phones,'ahsbaot')|strcmp(phones,'ehsbaot')|strcmp(phones,'sbaot')|strcmp(phones,'rehsbaot')|strcmp(phones,''));
            match = 'correct';  end;
    case 'small'
        if strcmp(word, 'small') & (strcmp(phones,'smaal')|strcmp(phones,''));
            match = 'correct';  end;
    case 'sorry'
        if strcmp(word, 'sorry') & (strcmp(phones,'saariy'));
            match = 'correct';  end;
    case 'silence'
        if strcmp(word, 'silence') & (strcmp(phones, 'sil'));
            match = 'correct';  end;        
    case 'star'
        if strcmp(word, 'star') & (strcmp(phones,'staar')|strcmp(phones,''));
            match = 'correct';  end;
    case 'red'
        if strcmp(word, 'red') & (strcmp(phones,'tuw')| strcmp(phones,'tax')|strcmp(phones,''));
            match = 'correct';  end;
    case 'reduced'
        if strcmp(word, 'reduced') & (strcmp(phones,'')| strcmp(phones,'IGNORE'));
            match = 'correct';  end;
    case 'triangle'
        if strcmp(word, 'triangle') & (strcmp(phones,'chraynggaxl')|strcmp(phones,'trayeynggaxl')|strcmp(phones,'chrayeynggaxl')|strcmp(phones,''));    
            match = 'correct';  end;
    case 'uh'
        if strcmp(word, 'uh') & (strcmp(phones,'ah'));
            match = 'correct';  end;
    case 'um'
        if strcmp(word, 'um') & (strcmp(phones,'ahm'));
            match = 'correct';  end;
    case 'unfilled'
        if strcmp(word, 'unfilled') & (strcmp(phones,'ahnfihld'));
            match = 'correct';  end;
    case 'up'
        if strcmp(word, 'up') & (strcmp(phones,'ahp'));
            match = 'correct';  end;
    case 'wait'
        if strcmp(word, 'wait') & (strcmp(phones,'weyt'));
            match = 'correct';  end;
    case 'yeah'
        if strcmp(word, 'yeah') & (strcmp(phones,'yae'));
            match = 'correct';  end;
    case 'yep'
        if strcmp(word, 'yep') & (strcmp(phones,'yehp'));
            match = 'correct';  end;
    case 'yes'
        if strcmp(word, 'yes') & (strcmp(phones,'yehs'));
            match = 'correct';  end;
    case 'yvee'
        if strcmp(word, 'yvee') & (strcmp(phones,'wayviy')|strcmp(phones,'iyviy')|strcmp(phones,'yayviy')|strcmp(phones,'yiyviy')|strcmp(phones,''));
            match = 'correct';  end;
end;


end
