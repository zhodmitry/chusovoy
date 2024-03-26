\ProvidesClass{details/practicumv1}[2022/08/26 V0.1 Андрей Чусов]
\typeout{Практикум ДВФУ}
\NeedsTeXFormat{LaTeX2e}

\LoadClass[oneside]{book}
\RequirePackage[russian]{babel}
\babelprovide[alph=lower, Alph=upper]{russian}
\RequirePackage[sortcites,backend=biber,autocite=plain,sorting=nty,giveninits=true]{biblatex}
%\renewcommand*{\bibfont}{\Large}
\RequirePackage[paper=a4paper]{geometry}
\RequirePackage{fontspec}
\RequirePackage[tableposition=above, figureposition=below]{caption}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{tocloft}
\RequirePackage{tikz}
\usetikzlibrary{calc}
\RequirePackage{etoolbox}
%\RequirePackage{floatrow}
\RequirePackage{details/counttotal}
\RequirePackage[pdfencoding=auto, hidelinks]{hyperref}
\RequirePackage[numbered, depth=3, openlevel=1]{bookmark}

\geometry{
	paperwidth = 210mm,
	paperheight = 297mm,
	left = 3cm,
	top = 2cm,
	right = 1.5cm,
	bottom = 2cm,
	footskip = 1cm,
	mag = 1000,
	a4paper
}

\input{details/workbook-font-setup.def}

\newdimen\pct@parindent\pct@parindent1.25cm
\newskip\pct@parskip\pct@parskip\z@ plus1em minus 0.1em
\newcount\pct@secsecvpenalty\pct@secsecvpenalty\@highpenalty

\DeclarePrintbibliographyDefaults{title=Список библиографических источников}

\pagestyle{empty}

\hbadness=10000

\captionsetup[figure]
{
	name={Рис},
	font={small},%
	justification={centering},%
	labelsep={period},%
	labelformat=simple,%
	%figurewithin=section
}
\DeclareCaptionLabelFormat{wbtable}{\hspace*{\fill}#1 #2}
\captionsetup[table]
{
	name={Таблица},
	textfont={small, bf},%
	labelfont=small,
	labelformat=wbtable,
	justification={centering},%
	labelsep={newline},%
	%labelformat=simple,
	%tablewithin=section,
	singlelinecheck=false
}
\counterwithin*{figure}{section}
\counterwithin*{table}{section}

\AtBeginDocument{%
	%algorithm2e redefinition in case it is used
	\def\algocf@captiontext#1#2{Алгоритм \thealgocf{}. \AlCapNameFnt{}#2}
}

\counterwithin*{equation}{section}  % implement desired numbering system

\renewcommand\cfttoctitlefont{\normalfont\normalsize}
\renewcommand\cftpartfont{\normalfont\normalsize}
\renewcommand\cftpartpagefont{\normalfont\normalsize}
\renewcommand\cftchapfont{\normalfont\normalsize}
\renewcommand\cftchappagefont{\normalfont\normalsize}
\renewcommand\cftsecpagefont{\normalfont\normalsize}
\renewcommand\cftsecfont{\normalfont\normalsize}
\setlength\cftbeforetoctitleskip{-1em}
\setlength\cftaftertoctitleskip{-1em}
\setlength\cftbeforepartskip{-1ex}
\setlength\cftbeforechapskip{-1ex}
\setlength\cftbeforesecskip{-1ex}
\renewcommand\cftparskip{6pt}
\renewcommand\cftsecindent{\z@}
\renewcommand\cftpartnumwidth{\z@}
\renewcommand\cftchapnumwidth{\z@}
\renewcommand\cftsecnumwidth{\z@}
\renewcommand{\cftpartleader}{\cftdotfill{0}}
\renewcommand{\cftchapleader}{\cftdotfill{0}}
\renewcommand{\cftsecleader}{\cftdotfill{0}}
\renewcommand{\cftsubsecleader}{\cftdotfill{0}}
\renewcommand{\cftmarktoc}{}
\setcounter{tocdepth}{1}
%\cftsetindents{section}{2ex}{2ex}
%\cftsetindents{subsection}{\z@}{\z@}
\addtocontents{toc}{\protect\thispagestyle{empty}}

\def\fps@figure{htbp}
\def\fps@table{htbp}
\setcounter{totalnumber}{5}
\setcounter{topnumber}{5}
\renewcommand{\topfraction}{.9}
\renewcommand{\textfraction}{.1}
\renewcommand{\bottomfraction}{.9}
\renewcommand{\floatpagefraction}{0.8}

\interfootnotelinepenalty=\@M

\AtBeginDocument{%
	\renewcommand\contentsname{\hspace{\fill}{\bfseries{}ОГЛАВЛЕНИЕ}\hspace*{\fill}\vspace{1em}\par\nobreak\@afterheading}
	\let\@toc\tableofcontents%
	\renewcommand\tableofcontents{\clearpage\@toc\thispagestyle{empty}\normalsize}
}

\pdfstringdefDisableCommands{%
	\def\XeLaTeX{XeLaTeX}
}

\ExplSyntaxOn
\cs_new_protected:Nn \remove_trailing_period:N {
	\regex_replace_once:nnN {(.*)\.$} {\1} #1
}
\NewDocumentCommand{\removetrailingperiod}{m} {
	\tl_set:Nn \l_tmpa_tl {#1}
	\remove_trailing_period:N \l_tmpa_tl
	\tl_use:N \l_tmpa_tl
}

\cs_new_protected:Nn \correct_quoting:N {\regex_replace_all:nnN {"([^"]*?)"}{«\1»} #1}
\NewDocumentCommand{\pct@correctquoting}{m}{\tl_set:Nn \l_tmpa_tl {#1} \correct_quoting:N \l_tmpa_tl}

\newif\if@pct@afteranysectiontitle\@pct@afteranysectiontitlefalse
\newif\if@pct@afterpartorsection\@pct@afterpartorsectionfalse
\newif\if@pct@insidepart\@pct@insidepartfalse
\newif\if@pct@insidepartorsection\@pct@insidepartorsectionfalse

\newcounter{pct@part}
\newcounter{pct@section}
\counterwithin*{pct@section}{pct@part}
\newcounter{pct@lab} %номер лабораторной
\counterwithin*{pct@lab}{pct@section}
\newcounter{pct@subsection}[pct@lab]
\newcounter{pct@subsubsection}[pct@subsection]
\def\thelabnumber{\thepct@lab}

\def\pct@addpart#1{
	{\centering\bfseries#1\par}
	\parindent\pct@parindent
	\nobreak\@afterheading
}

\NewDocumentCommand{\pct@part}{som} {
	\tl_set:Nn \l_tmpa_tl {#3}
	\remove_trailing_period:N \l_tmpa_tl
	\correct_quoting:N \l_tmpa_tl
	\str_if_eq:eeTF{\str_foldcase:V \l_tmpa_tl}{\str_foldcase:n{введение}}{\pagestyle{plain}}{
		\str_if_eq:eeTF{\str_foldcase:V \l_tmpa_tl}{\str_foldcase:n{предисловие}}{\pagestyle{plain}}{}}
	\clearpage
	\parindent\z@
	\IfBooleanTF{#1}{
		\tl_set:Nx \l_tmpb_tl {\text_uppercase:n{\tl_use:N \l_tmpa_tl}}
	}{
		\refstepcounter{pct@part}
		\tl_set:Nx \l_tmpb_tl {ЧАСТЬ\ \protect{\thepct@part}.\ \text_uppercase:n{\tl_use:N \l_tmpa_tl}}
	}
	\pct@addpart{\tl_use:N \l_tmpb_tl}
	\addcontentsline{toc}{part}{\tl_use:N \l_tmpb_tl}
	\@pct@afteranysectiontitletrue\@pct@afterpartorsectiontrue
	\everypar{\@pct@afteranysectiontitlefalse\@pct@afterpartorsectionfalse\everypar{}}
	\@pct@insideparttrue
	\@pct@insidepartorsectiontrue
	\IfValueT{#2}{\label{#2}}
	\vskip1ex plus 0.5ex minus 0.2ex
}

%\NewDocumentCommand{\pct@appendix}{som} {
%	\tl_set:Nn \l_tmpa_tl {#3}
%	\remove_trailing_period:N \l_tmpa_tl
%	\clearpage
%	\parindent\z@
%	\IfBooleanTF{#1}{
%		\captionsetup*[figure]{figurewithin=none}
%		\captionsetup*[table]{tablewithin=none}
%		\setcounter{figure}{\z@}
%		\setcounter{table}{\z@}
%		\pct@addchapter{Приложение\\\tl_use:N \l_tmpa_tl}
%		\addcontentsline{toc}{chapter}{Приложение.\ \tl_use:N \l_tmpa_tl}
%	}{
%		\refstepcounter{appendix}
%		\pct@addchapter{Приложение\ \protect{\@Alph\theappendix}\\\tl_use:N \l_tmpa_tl}
%		\addcontentsline{toc}{chapter}{Приложение\ \protect{\@Alph\theappendix}.\ \tl_use:N \l_tmpa_tl}
%	}
%	\@pct@aftersectiontrue\everypar{\@pct@aftersectionfalse\everypar{}}
%	\IfValueT{#2}{\label{#2}}
%	\vskip1ex plus 0.5ex minus 0.2ex
%}

\RenewDocumentCommand{\part}{}{\pct@part}

\RenewDocumentCommand{\chapter}{}{\ClassError{details/practicumv1}{Главы\ не\ поддерживаются\ документами\ типа\ "Практикум".}}

\NewDocumentCommand{\pct@addsection}{m}{
	{\centering\bfseries#1\par}
	\nobreak\@afterheading
	\parindent\pct@parindent
}

\NewDocumentCommand{\pct@section}{som}{
	\tl_set:Nn \l_tmpa_tl {#3}
	\correct_quoting:N \l_tmpa_tl
	\remove_trailing_period:N \l_tmpa_tl
	\@pct@insidepartorsectionfalse
	\str_if_eq:eeTF{\str_foldcase:V \l_tmpa_tl}{\str_foldcase:n{введение}}{\pagestyle{plain}}{
		\str_if_eq:eeTF{\str_foldcase:V \l_tmpa_tl}{\str_foldcase:n{предисловие}}{\pagestyle{plain}}{\@pct@insidepartorsectiontrue}}
	\if@pct@afterpartorsection\ifhmode\par\fi\addvspace{1ex plus 0.5ex minus 0.1ex}\penalty\pct@secsecvpenalty\else\clearpage\fi
	\parindent\z@
	\if@pct@insidepart
		\IfBooleanTF {#1} {
			\tl_set_eq:NN \l_tmpb_tl \l_tmpa_tl
		}{
			\refstepcounter{pct@section}
			\tl_set:Nx \l_tmpb_tl {Раздел\ \protect{\thepct@section}.\ \tl_use:N \l_tmpa_tl}
		}
	\else
		\IfBooleanTF {#1} {
			\tl_set:Nx \l_tmpb_tl {\text_uppercase:n{\tl_use:N \l_tmpa_tl}}
		}{
			\refstepcounter{pct@section}
			\tl_set:Nx \l_tmpb_tl {РАЗДЕЛ\ \protect{\thepct@section}.\ \text_uppercase:n{\tl_use:N \l_tmpa_tl}}
		}
	\fi
	\addcontentsline{toc}{chapter}{\tl_use:N \l_tmpb_tl}
	\pct@addsection{\tl_use:N \l_tmpb_tl}
	\@pct@afteranysectiontitletrue\@pct@afterpartorsectiontrue
	\everypar{\@pct@afteranysectiontitlefalse\@pct@afterpartorsectionfalse\everypar{}}
	\IfValueT{#2}{\label{#2}}
	\vskip1ex plus 0.5ex minus 0.2ex
}

\RenewDocumentCommand{\section}{}{\pct@section}

\NewDocumentCommand{\lab}{om}{
	\tl_set:Nn \l_tmpa_tl {#2}
	\correct_quoting:N \l_tmpa_tl
	\remove_trailing_period:N \l_tmpa_tl
	\if@pct@afterpartorsection\ifhmode\par\fi\addvspace{1ex plus 0.5ex minus 0.1ex}\penalty\pct@secsecvpenalty\else\clearpage\fi
	\parindent\z@
	\refstepcounter{pct@lab}
	\if@pct@insidepartorsection
		\tl_set:No \l_tmpb_tl {Лабораторная\ работа\ №\ \protect{\thepct@lab}.\ \tl_use:N \l_tmpa_tl}
	\else
		\tl_set:Nx \l_tmpb_tl {Лабораторная\ работа\ №\ \protect{\thepct@lab}.\ \text_uppercase:n{\tl_use:N \l_tmpa_tl}}
	\fi
	\addcontentsline{toc}{section}{\tl_use:N \l_tmpb_tl}
	{\centering\bfseries Лабораторная\ работа\ № \protect{\thepct@lab}\par\vskip1em\text_uppercase:n{\tl_use:N \l_tmpa_tl}\par\vskip1.2em}
	\nobreak\@afterheading
	\parindent\pct@parindent
	\@pct@afteranysectiontitletrue\everypar{\@pct@afteranysectiontitlefalse\everypar{}}
	\IfValueT{#1}{\label{#1}}
	\vskip1ex plus 0.5ex minus 0.2ex
}

\NewDocumentCommand{\pct@addsubsection}{m}{
	{\centering\bfseries#1\par}
	\nobreak\@afterheading
	\parindent\pct@parindent
}

\NewDocumentCommand{\pct@subsection}{som}{
	\tl_set:Nn \l_tmpa_tl {#3}
	\correct_quoting:N \l_tmpa_tl
	\remove_trailing_period:N \l_tmpa_tl
	\parindent\z@\ifhmode\par\fi
	\addvspace{1ex plus 0.5ex minus 0.1ex}
	\if@pct@afteranysectiontitle\penalty\pct@secsecvpenalty\fi
	\IfBooleanTF{#1}{
		\addcontentsline{toc}{subsection}{\tl_use:N \l_tmpa_tl}
		\pct@addsubsection{\tl_use:N \l_tmpa_tl}
	}{
		\refstepcounter{pct@subsection}
		\addcontentsline{toc}{subsection}{\protect{\thepct@subsection}.\ \tl_use:N \l_tmpa_tl}
		\pct@addsubsection{\protect{\thepct@subsection}.\ \tl_use:N \l_tmpa_tl}
	}
	\@pct@afteranysectiontitletrue\everypar{\@pct@afteranysectiontitlefalse\everypar{}}
	\IfValueT{#2}{\label{#2}}
	\vskip1ex plus 0.5ex minus 0.2ex
}

\RenewDocumentCommand{\subsection}{}{\pct@subsection}

\NewDocumentCommand{\pct@addsubsubsection}{m}{
	{\centering\itshape#1\par}
	\nobreak\@afterheading
}

\NewDocumentCommand{\pct@subsubsection}{som}{
	\tl_set:Nn \l_tmpa_tl {#3}
	\correct_quoting:N \l_tmpa_tl
	\tl_set_eq:NN \l_tmpb_tl \l_tmpa_tl
	\remove_trailing_period:N \l_tmpb_tl
	\ifhmode\par\fi
	\parindent\z@
	\addvspace{0.5em plus 0.5em minus 0.1em}
	\if@pct@afteranysectiontitle\penalty\pct@secsecvpenalty\fi
	\IfBooleanTF{#1}{
		\addcontentsline{toc}{subsubsection}{\tl_use:N \l_tmpb_tl}
		\pct@addsubsubsection{\tl_use:N \l_tmpa_tl}
	}{
		\refstepcounter{pct@subsubsection}
		\addcontentsline{toc}{subsubsection}{\protect{\thepct@subsubsection}\ \tl_use:N \l_tmpb_tl}
		\pct@addsubsubsection{\protect{\thepct@subsubsection}.\ \tl_use:N \l_tmpa_tl}
	}
	\parindent\pct@parindent
	\@pct@afteranysectiontitletrue\everypar{\@pct@afteranysectiontitlefalse\everypar{}}
	\IfValueT{#2}{\label{#2}}
	\vskip1ex plus 0.5ex minus 0.2ex
}

\RenewDocumentCommand{\subsubsection}{}{\pct@subsubsection}

\RenewDocumentCommand{\appendix}{}{\par
	\newcounter{appendix}
	\committotalcounters{}
	\renewcommand{\appendixname}{}
	\gdef\thechapter{\@Alph\c@appendix}
	\renewcommand{\chapter}{\pct@appendix}
}
\ExplSyntaxOff

\newcounter{itemlistctr}
\newcommand{\makenumlabel}[1]{#1.\hfill}
\newenvironment{itemlist}
{
	\begin{list}
    {\arabic{itemlistctr}}
    {\usecounter{itemlistctr}
     \setlength{\labelwidth}{1cm}
     \setlength{\labelsep}{0cm}
     \setlength{\leftmargin}{\z@}
     \setlength{\rightmargin}{\z@}
     \setlength{\itemindent}{2cm}
     \setlength{\itemsep}{\z@}
     \setlength{\parsep}{\z@}
     \setlength{\parskip}{\z@}
     \setlength{\partopsep}{\z@}
     \let\makelabel=\makenumlabel
    }
}
{\end{list}}

\DeclareNameAlias{author}{family-given}
\DeclareFieldFormat{title}{#1}
\DeclareFieldFormat{subtitle}{#1}
\DeclareBibliographyDriver{standard}
{%
	\printfield{title}%
	\newunit
	\printfield{subtitle}%
	\newunit\newblock
	\printfield{type}%
	\newunit\newblock
	\printlist{organization}%
	\newunit
	\printfield{month}, \printfield{year}%
	\finentry
}
\DeclareSourcemap{
	\maps[datatype=bibtex]{
		\map[overwrite]
		{
			\step[fieldsource=author, match=\regexp{^[А-Яа-я].+}, final]
			\step[fieldset=presort, fieldvalue=1, append]
		}
		\map[overwrite]
		{
			\step[notfield=author, final]
			\step[fieldsource=title, match=\regexp{^[А-Яа-я].+}, final]
			\step[fieldset=presort, fieldvalue=1, append]
		}
		\map[overwrite]
		{
			\step[fieldsource=author, match=\regexp{^[A-Za-z].+}, final]
			\step[fieldset=presort, fieldvalue=2, append]
		}
		\map[overwrite]
		{
			\step[notfield=author, final]
			\step[fieldsource=title, match=\regexp{^[A-Za-z].+}, final]
			\step[fieldset=presort, fieldvalue=2, append]
		}
	}
}
\defbibenvironment{bibliography}{\begin{itemlist}}{\end{itemlist}}{\item}%
\renewbibmacro*{url}{\printfield[url]{urlraw}}

\input{details/masterspecialties.def}
\input{details/barchelorspecialties.def}

\ExplSyntaxOn

\NewDocumentCommand{\decodespecialty}{m}{
	\decode_barchelor_specialty:Nn \l_tmpa_tl {#1}
	\str_if_empty:NT \l_tmpa_tl {
		\decode_master_specialty:Nn \l_tmpa_tl {#1}
		\str_if_empty:NT \l_tmpa_tl {
			\tl_set:Nn \l_tmpa_tl {
				\todo{НЕИЗВЕСТНАЯ\ СПЕЦИАЛЬНОСТЬ\ #1}
			}
		}
	}
	\tl_use:N \l_tmpa_tl
}
\ExplSyntaxOff

\ExplSyntaxOn
\NewDocumentCommand {\authors} {m} {
	\seq_if_empty:NTF {\seq_author_name} {} {\ClassError{details/workbookv1}{Authors~of~the~workbook~were~specefied~more~than~once}}
	\clist_set:Nn \l_tmpa_clist {#1}
	\clist_use:Nn \l_tmpa_clist {}
}
\seq_clear_new:N \seq_author_name
\seq_clear_new:N \seq_author_degree
\seq_clear_new:N \seq_author_employment
\seq_clear_new:N \seq_author_affiliation
\cs_new_protected:Nn \tl_normalize_affiliation:N {\regex_replace_once:nnN {^([^,]+),\ *([\w\-А-Яа-я]+)$}{\1\ \(\2\)} #1}
\DeclareDocumentCommand{\author} {m m O{Дальневосточный~федеральный~университет~(Владивосток)} m} {
	\seq_put_right:Nn \seq_author_degree{#1}
	\seq_put_right:Nn \seq_author_employment{#2}
	\tl_set:Nn \l_tmpa_tl {#3}
	\tl_normalize_affiliation:N \l_tmpa_tl
	\seq_put_right:NV \seq_author_affiliation \l_tmpa_tl
	\seq_put_right:Nn \seq_author_name {#4}
}
\NewDocumentCommand{\theauthorname}{O{1}} {
	\seq_item:Nn \seq_author_name {#1}
}
\NewDocumentCommand{\theauthordegree}{O{1}} {
	\seq_item:Nn \seq_author_degree {#1}
}
\NewDocumentCommand{\theauthoremployment} {O{1}} {
	\seq_item:Nn \seq_author_employment{#1}
}
\tl_clear_new:N \tl_institute
\NewDocumentCommand{\institute}{m}{\tl_set:Nn \tl_institute {#1}}
\NewDocumentCommand{\theinstitute}{} {\tl_use:N \tl_institute}
\tl_clear_new:N \tl_udc
\NewDocumentCommand{\udc}{m}{\tl_set:Nn \tl_udc {#1}}
\NewDocumentCommand{\theudc}{}{\tl_use:N \tl_udc}
\tl_clear_new:N \tl_bbc
\NewDocumentCommand{\bbc}{m}{\tl_set:Nn \tl_bbc {#1}}
\NewDocumentCommand{\thebbc}{}{\tl_use:N \tl_bbc}
\tl_clear_new:N \tl_amark
\NewDocumentCommand{\amark}{m}{\tl_set:Nn \tl_amark {#1}}
\NewDocumentCommand{\theamark}{}{\tl_use:N \tl_amark}
\tl_clear_new:N \tl_isbn
\NewDocumentCommand{\isbn}{m}{\tl_set:Nn \tl_isbn {#1}}
\NewDocumentCommand{\theisbn}{}{\tl_use:N \tl_isbn}
\tl_clear_new:N \tl_copyrighttext
\NewDocumentCommand{\copyrighttext}{m}{\tl_set:Nn \tl_copyrighttext {#1}}
\NewDocumentCommand{\thecopyrighttext}{}{\tl_use:N \tl_copyrighttext}
\tl_new:N \tl_location
\tl_set:Nn \tl_location {Владивосток}
\NewDocumentCommand{\location}{m}{\tl_set:Nn \tl_location {#1}}
\NewDocumentCommand{\thelocation}{}{\tl_use:N \tl_location}
\tl_clear_new:N \tl_title
\RenewDocumentCommand{\title}{m}{\tl_set:Nn \tl_title {#1} \correct_quoting:N \tl_title}
\NewExpandableDocumentCommand{\thetitle}{}{\tl_use:N \tl_title}
\tl_clear_new:N \tl_subtitle
\NewDocumentCommand{\subtitle}{m}{\tl_set:Nn \tl_subtitle {#1} \correct_quoting:N \tl_subtitle}
\NewDocumentCommand{\thesubtitle}{}{\tl_use:N \tl_subtitle}
\tl_clear_new:N \tl_audience
\NewDocumentCommand{\audience}{m}{\tl_set:Nn \tl_audience {#1} \correct_quoting:N \tl_audience}
\NewDocumentCommand{\theaudience}{}{\tl_use:N \tl_audience}
\tl_clear_new:N \tl_issue
\NewDocumentCommand{\issue}{m}{\tl_set:Nn \tl_issue {#1}}
\NewDocumentCommand{\theissue}{}{\tl_use:N \tl_issue}
\tl_clear_new:N \tl_issuetype
\NewDocumentCommand{\issuetype}{m}{\tl_set:Nx \tl_issuetype {#1}}
\NewDocumentCommand{\theissuetype}{}{\tl_use:N \tl_issuetype}
\tl_clear_new:N \tl_recommendation
\NewDocumentCommand{\recommendation}{m}{\tl_set:Nn \tl_recommendation {#1}}
\NewDocumentCommand{\therecommendation}{}{\tl_use:N \tl_recommendation}
\NewDocumentEnvironment{annotation} {+b}{}{\tl_gset:Nn \tl_annotation {#1}}
\seq_new:N \seq_keywords_ru
\seq_new:N \seq_keywords_en
\NewDocumentEnvironment{keywords}{O{ru}+b}{
	\tl_set:Nx \l_tmpa_tl {#1}
	\str_case_e:nnF {\str_foldcase:V{\l_tmpa_tl}} {
		{\str_foldcase:n{ru}}{\seq_gset_split:Nnn\seq_keywords_ru {,} {#2}}
		{\str_foldcase:n{en}}{\seq_gset_split:Nnn\seq_keywords_en {,} {#2}}
	}{\ClassError{details/workbook}{Unsupported~keywords~language~\str_foldcase:V \l_tmpa_tl}}
}{}
\NewDocumentEnvironment{publisherblock}{}{}{}
\seq_clear_new:N \seq_pub_info
\NewDocumentEnvironment{publisherinfo}{+b}{
	\seq_gput_right:Nn \seq_pub_info {#1}
}{}

\NewDocumentCommand{\publicationinfo}{+m}{
	\seq_gput_right:Nn \seq_pub_info {#1}
}

\RenewDocumentCommand{\titlepage}{} {
	\large
	\setlength{\parindent}{\z@}
	\begin{minipage}{\textwidth}
		\sffamily
		\begin{center}
			Дальневосточный~федеральный~университет
			\normalsize\\
			\theinstitute{}
		\end{center}
	\end{minipage}
	\vspace{7em}
	\par
	\begin{minipage}{\textwidth}
	\begin{center}
		\clist_clear:N \l_tmpa_clist
		\seq_map_inline:Nn \seq_author_name {
			\clist_put_right:Nn \l_tmpa_clist {\@fullnameinitialslastname{##1}}
		}
		\LARGE
		\clist_use:Nn \l_tmpa_clist {,~}\par
		\vspace{3em}
		\bfseries\text_uppercase:n {\thetitle}\normalfont\par
		\normalsize
		\tl_if_empty:NF \tl_subtitle {\large\vspace{1.5em}\tl_use:N \tl_subtitle\par}
		\tl_if_empty:NF \tl_audience {\large\vspace{1.5em}\tl_use:N \tl_audience\par}
		\tl_if_empty:NF \tl_issue {\large\vspace{1.5em}\tl_use:N \tl_issue\par}
		\tl_if_empty:NF \tl_issuetype {\vspace{1em}\large\tl_use:N \tl_issuetype\par}
		\tl_if_empty:NF \tl_recommendation {\itshape\vspace{1.5em}Рекомендовано\par\tl_use:N \tl_recommendation\normalfont\par}
		\ifdraught
			\vspace{1ex}
			\small
			\int_compare:nNnTF {\seq_count:N \seq_author_name} = {1} {
				Я\ подтверждаю
			}{
				Мы\ подтверждаем
			}
			,\ что\ эта\ работа\ является\ оригинальной\ и\ не\ была\ опубликована\ в\ другом\ месте.\ В\ настоящее\ время\ она\ не\ рассматривается\ для\ публикации\ в\ каком-либо\ другом\ издательстве.\\
			\vspace{1em}
			\clist_clear:N \l_tmpa_clist
			\def\pct@tikzline{\tikz\draw[overlay](0, -1pt) -- +(3cm, 0);\hspace{3cm}}
			\seq_map_inline:Nn \seq_author_name {
				\clist_put_right:Nn \l_tmpa_clist {\pct@tikzline\nobreakspace/\ \@fullnameinitialslastname{##1}\ /}
			}
			\clist_use:Nn \l_tmpa_clist {,\par\vspace{1ex}}.
		\fi
	\end{center}\end{minipage}
	\vspace*{\fill}
	\begin{center}
		\sffamily\normalsize
		\includegraphics[width=1.8cm, height=2.5cm]{details/leo-logo}\par
		\thelocation\par
		Издательство\ Дальневосточного\ федерального\ университета\par
		\the\year\par
		\normalfont\normalsize
	\end{center}
	\clearpage
}

\NewDocumentEnvironment{copyrightpage}{}{
	\fontsize{10pt}{11pt}\selectfont\setlength{\parindent}{\z@}\sffamily
	\begin{minipage}{\textwidth}
		УДК\ \theudc{}\\
		ББК\ \thebbc{}\\
		\hspace*{\widthof{ББК~}}\theamark
	\end{minipage}
	\par\small
}{
	\vspace{1em}\normalfont\setlength{\parindent}{\pct@parindent}
	\begin{center}
		\int_compare:nNnTF {\seq_count:N \seq_author_name} < {2} {
			\textit{Автор}\par
			\textbf{\seq_item:Nn \seq_author_name {1}}~---~
			\clist_clear:N \l_tmpa_clist
			\tl_set:Nx \l_tmpa_tl {\seq_item:Nn \seq_author_degree {1}}
			\tl_if_empty:NF \l_tmpa_tl {
				\abbreviate_degree_short:N \l_tmpa_tl
				\clist_put_right:Nx \l_tmpa_clist \l_tmpa_tl
			}
			\clist_put_right:Nx \l_tmpa_clist {\seq_item:Nn \seq_author_employment {1}}
			\clist_use:Nn \l_tmpa_clist {,~}\par
			\tl_set:Nx \l_tmpa_tl {\seq_item:Nn \seq_author_affiliation {1}}
			\regex_replace_once:nnNF {^([^\(]*)\(([\w\-А-Яа-я]+)\)$} {\c{textit}{\1}\ \(\2\)} \l_tmpa_tl {
				\ClassWarning{details/workbook1}{Unrecognized~author~affiliation~pattern}
			}
			\tl_use:N \l_tmpa_tl\par
		}{
			\textit{Авторы}\par
			\seq_set_eq:NN \l_tmpa_seq \seq_author_affiliation
			\seq_remove_duplicates:N \l_tmpa_seq
			\int_compare:nNnTF {\seq_count:N \l_tmpa_seq} = {1} {
				\int_set:Nn \l_tmpa_int {1}
				\int_set:Nn \l_tmpb_int {\seq_count:N \seq_author_name}
				\int_do_while:nn {\l_tmpa_int <= \l_tmpb_int} {
					\textbf{\seq_item:Nn \seq_author_name {\int_use:N \l_tmpa_int}}~---~
					\clist_clear:N \l_tmpa_clist
					\tl_set:Nx \l_tmpa_tl {\seq_item:Nn \seq_author_degree {\int_use:N \l_tmpa_int}}
					\tl_if_empty:NF \l_tmpa_tl {
						\abbreviate_degree_short:N \l_tmpa_tl
						\clist_put_right:Nx \l_tmpa_clist \l_tmpa_tl
					}
					\clist_put_right:Nx \l_tmpa_clist {\seq_item:Nn \seq_author_employment {\int_use:N \l_tmpa_int}}
					\clist_use:Nn \l_tmpa_clist {,~}\par
					\int_incr:N \l_tmpa_int
				}
				\tl_set:Nx \l_tmpa_tl {\seq_item:Nn \seq_author_affiliation {1}}
				\regex_replace_once:nnNF {^([^\(]*)\(([\w\-А-Яа-я]+)\)$} {\c{textit}{\1}\ \(\2\)} \l_tmpa_tl {
					\ClassWarning{details/workbook1}{Unrecognized~author~affiliation~pattern}
				}
				\tl_use:N \l_tmpa_tl\par
			}{
				\int_set:Nn \l_tmpa_int {1}
				\int_set:Nn \l_tmpb_int {\seq_count:N \seq_author_name}
				\int_do_while:nn {\l_tmpa_int <= \l_tmpb_int} {
					\textbf{\seq_item:Nn \seq_author_name {\int_use:N \l_tmpa_int}}~---~
					\clist_clear:N \l_tmpa_clist
					\tl_set:Nx \l_tmpa_tl {\seq_item:Nn \seq_author_degree {\int_use:N \l_tmpa_int}}
					\tl_if_empty:NF \l_tmpa_tl {
						\abbreviate_degree_short:N \l_tmpa_tl
						\clist_put_right:Nx \l_tmpa_clist \l_tmpa_tl
					}
					\clist_put_right:Nx \l_tmpa_clist {\seq_item:Nn \seq_author_employment {\int_use:N \l_tmpa_int}}
					\clist_use:Nn \l_tmpa_clist {,~}\par
					\tl_set:Nx \l_tmpa_tl {\seq_item:Nn \seq_author_affiliation {\int_use:N \l_tmpa_int}}
					\regex_replace_once:nnNF {^([^\(]*)\(([\w\-А-Яа-я]+)\)$} {\c{textit}{\1}\ \(\2\)} \l_tmpa_tl {
						\ClassWarning{details/workbook1}{Unrecognized~author~affiliation~pattern}
					}
					\tl_use:N \l_tmpa_tl\par
					\int_incr:N \l_tmpa_int
				}
			}
		}
	\end{center}
	\clist_clear:N \l_tmpa_clist
	\seq_map_inline:Nn \seq_author_name {
		\tl_set:Nn \l_tmpa_tl {##1}
		\fullname_to_lastname_initials:N \l_tmpa_tl
		\clist_put_right:NV \l_tmpa_clist \l_tmpa_tl
	}
	\setlength{\parindent}{\pct@parindent}\par\textbf{\clist_use:Nn \l_tmpa_clist {,\ }}\ 
	\thetitle{}
	\tl_if_empty:NF \tl_subtitle {:~\tl_use:N \tl_subtitle}
	\tl_if_empty:NF \tl_audience {
		\tl_set_eq:NN \l_tmpa_tl \tl_audience
		\regex_replace_all:nnN{\ *\c{\\}\ *}{\ } \l_tmpa_tl
		:~\tl_use:N \l_tmpa_tl
	}
	\tl_if_empty:NF \tl_issuetype {
		\tl_set_eq:NN \l_tmpa_tl \tl_issuetype
		\regex_replace_all:nnN{.*?\c{\\}(.*)$}{\1} \l_tmpa_tl
		:~\tl_use:N \l_tmpa_tl
	}
	\ /~Политехнический~институт~ДВФУ.
	\tl_if_empty:NF \tl_issue {\ --\ \tl_set:No \l_tmpa_tl \tl_issue \abbreviate_issue:N\l_tmpa_tl \tl_use:N \l_tmpa_tl}
	\ --\ \tl_set:No \l_tmpa_tl {\tl_location :\ Изд-во\ Дальневост.\ федеральн.\ ун-та}
	\tl_use:N \l_tmpa_tl,\ \the\year{}.\ --\ 1\nobreakspace{}CD.\ [\totalpagecount*\ с.].\ --\ Систем.\ требования:\ Acrobat\ Reader,\ Foxit\ Reader\ либо\ другой\ их\ аналог.\ --\ ISBN\ \tl_use:N \tl_isbn.\ --\ Текст:\ электронный.\par
	\vspace{1em}\tl_use:N \tl_annotation\par
	\seq_if_empty:NF \seq_keywords_ru {\itshape Ключевые\ слова:\normalfont\ \seq_use:Nn \seq_keywords_ru {,\ }}\par
	\seq_if_empty:NF \seq_keywords_en {\itshape Keywords:\normalfont\ \seq_use:Nn \seq_keywords_en {,\ }}\par
	\vspace*{\fill}
	\seq_if_empty:NF \seq_pub_info {
		\begin{center}
			\fontsize{10pt}{13.5pt}\selectfont
			\let\oldnl\\
			\def\\{\oldnl\relax}
			\seq_use:Nn \seq_pub_info {\par\vspace{1em}}
			\let\\\oldnl
		\end{center}
	}
	\vspace{1em}
	\fontsize{10pt}{13pt}\selectfont
	\setlength{\parindent}{\z@}
	\hspace{\fill}Защищено\ от\ копирования \\
	ISBN\ \tl_use:N \tl_isbn \hspace{\fill}\copyright{}\ ФГАОУ\ ВО\ \quot{ДВФУ},\ \the\year
	\clearpage
	\normalfont\normalsize
}

\newcounter{pct@assignment} %задачи
\counterwithin{pct@assignment}{chapter}
\NewDocumentCommand{\assignmentlist}{O{Задачи\ для\ самостоятельного\ решения}}{\section*{#1}\setcounter{pct@assignment}{\z@}}
\NewDocumentCommand{\assignment}{+o} {
	\ifhmode\par\fi\parindent\z@
	\addvspace{1ex}
	\if@pct@aftersection\penalty\pct@secsecvpenalty\fi
	\refstepcounter{pct@assignment}
	{\centering\bfseries\itshape{}Задача\ \thepct@assignment\relax\IfValueT{#1}{.\ #1.}\par\nobreak\@afterheading}
	\parindent\pct@parindent
	\@pct@aftersectiontrue\everypar{\@pct@aftersectionfalse\everypar{}}
}

\ExplSyntaxOff
\let\totalprintlists@base\totalprintlists
\renewcommand{\totalprintlists}{\@ifstar{\totalprintlists@base*{250}{2159}}{\totalprintlists@base{250}{2159}}}
\input{details/contractions.def}

\AtBeginDocument{%
	\parskip\pct@parskip
	\parindent\pct@parindent
}
