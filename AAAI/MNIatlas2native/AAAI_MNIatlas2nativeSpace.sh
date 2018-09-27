#!/bin/bash

# CNS/Scripts folder
MNIatlas2native_folder=$(dirname $(which $0))
AAAI_folder=$(dirname "${MNIatlas2native_folder}")
CNS_folder=$(dirname "${AAAI_folder}")
Scripts_folder=${CNS_folder}/Scripts


# ========== usage function =========== #
usage()
{
cat << EOF

DESCRIPTION: This script brings MNI space atlas to individual space.

USAGE: 

	COMPULSORY:

		--natv|-n        <native space data>        path to the native space image that atlas is warped back to. Better to be brain. If head, use --NnbvrFSL or --NnbtrCNS.
		--t1|-i          <T1 image>                 path to corresponding T1 head image (need to either specify --t1msk or --TnbtrFSL or --TnbtrCNS)
		--atlas|-a       <atlas in MNI space>       path to MNI space atlas
		--Odir|-o        <output directory>         output directory
		--Onam|-m        <output base name>         output base name


	OPTIONAL:

		Options for MNI-to-T1 reverse warping:

		--Wintp|-wp       <interp for warping>      the interpolation method for T1-MNI flirt'ing (nn, trilinear,sinc,spline. default: nn)
		--Wstt|-wt        <search range start>      the start of searching range used with flirt'ing T1 to MNI (before fnirt warping. -180~180. default: 0)
		--Wend|-wd        <search range end>        the end of searching range used with flirt'ing T1 to MNI (before fnirt warping. -180~180. default: 0)
		--Wdof|-wf        <DOF>                     the DOF for flirt'ing T1 to MNI (before fnirt warping. 6, 7, 9, 12. default: 6)


		Options for T1-to-native reverse registration:

		--Rintp|-rp       <interp for reg>          the interpolation method for T1-native registration (trilinear,nearestneighbour,sinc,spline. default=nearestneighbour)
		--Rstt|-rt        <search range start>      the start of searching range (-180~180. default=0)
		--Rend|-rd        <search range end>        the end of searching range (-180~180. default=0)
		--Rdof|-rf        <DOF>                     DOF for flirt'ing native to T1 (6, 7, 9, 12. default: 7)

		Other options:

		--NnbtrFSL        <frac int>                using FSL's bet (require fractional intensity input) to perform non-brain tissue removal (NBTR) on native image data
		--NnbtrCNS        <path to spm12>           using CNS's NBTR native data
		--t1msk|-k        <T1 brain mask>           path to T1 brain mask
		--TnbtrFSL        <frac int>                using FSL's bet (require fractional intensity input) to perform non-brain tissue removal (NBTR) on T1
		--TnbtrCNS        <path to spm12>           using CNS's NBTR T1
		--help|-h                                   display this message
		
EOF
}



# ========== passing parameters ============ #
OPTIND=1

if [ "$#" = "0" ]; then
	usage
	exit 0
fi

Nnbtr="OFF" # indicator for NBTR native
Tnbtr="OFF" # indicator for NBTR T1

while [[ $# > 0 ]]; do
	key=$1
	shift

	case ${key} in

		# compulsory flags
		# ----------------
		--natv|-n)
			nativeImg=$1
			shift
			;;

		--t1|-i)
			T1=$1
			shift
			;;

		--atlas|-a)
			atlas=$1
			shift
			;;

		--Odir|-o)
			Odir=$1
			shift
			;;

		--Onam|-m)
			Onam=$1
			shift
			;;


		# optional flags
		# --------------
		--Wintp|-wp)
			Wintp=$1
			shift
			;;

		--Wstt|-wt)
			Wstt=$1
			shift
			;;

		--Wend|-wd)
			Wend=$1
			shift
			;;

		--Wdof|-wf)
			Wdof=$1
			shift
			;;

		--Rintp|-rp)
			Rintp=$1
			shift
			;;

		--Rstt|-rt)
			Rstt=$1
			shift
			;;

		--Rend|-rd)
			Rend=$1
			shift
			;;

		--Rdof|-rf)
			Rdof=$1
			shift
			;;


		--NnbtrFSL)
			Nnbtr="FSL"
			Nfi=$1
			shift
			;;

		--NnbtrCNS)
			Nnbtr="CNS"
			Nspm12path=$1
			shift
			;;

		--t1msk|-k)
			T1mask=$1
			shift
			;;

		--TnbtrFSL)
			Tnbtr="FSL"
			Tfi=$1
			shift
			;;

		--TnbtrCNS)
			Tnbtr="CNS"
			Tspm12path=$1
			shift
			;;

		--help|-h)
			usage
			exit 0
			;;

		*)
			echo
			echo "ERROR: unknown option ${key}."
			echo
			usage
			exit 1
			;;

	esac
done


# ========== checking if compusory arguments are null ============ #
if [ -z ${nativeImg:+a} ]; then
	echo
	echo "ERROR: nativeImg (--natv|-n) is not properly set."
	echo
	usage
	exit 1
fi

if [ -z ${T1:+a} ]; then
	echo
	echo "ERROR: T1 (--t1|-i) is not properly set."
	echo
	usage
	exit 1
fi

if [ -z ${atlas:+a} ]; then
	echo
	echo "ERROR: atlas (--atlas|-a) is not properly set."
	echo
	usage
	exit 1
fi

if [ -z ${Odir+a} ]; then
	echo
	echo "ERROR: Odir (--Odir|-o) is not properly set."
	echo
	usage
	exit 1
fi

if [ -z ${Onam+a} ]; then
	echo
	echo "ERROR: Onam (--Onam|-m) is not properly set."
	echo
	usage
	exit 1
fi


# =========== other missing arg errors ============== #
if [ "${Nnbtr}" = "FSL" ] && [ -z ${Nfi:+a} ]; then
	echo
	echo "ERROR: fractional intensity for native data bet (--NnbtrFSL) is not properly set."
	echo
	usage
	exit 1
fi

if [ "${Nnbtr}" = "CNS" ] && [ -z ${Nspm12path:+a} ]; then
	echo
	echo "ERROR: spm12path for native data NBTR (--NnbtrCNS) is not properly set."
	echo
	usage
	exit 1
fi

if [ "${Tnbtr}" = "FSL" ] && [ -z ${Tfi:+a} ]; then
	echo
	echo "ERROR: fractional intensity for T1 bet (--TnbtrFSL) is not properly set."
	echo
	usage
	exit 1
fi

if [ "${Tnbtr}" = "CNS" ] && [ -z ${Tspm12path:+a} ]; then
	echo
	echo "ERROR: spm12path for T1 NBTR (--TnbtrCNS) is not properly set."
	echo
	usage
	exit 1
fi

if [ -z ${T1mask:+a} ] && [ "${Tnbtr}" = "OFF" ]; then
	echo
	echo "ERROR: either T1mask (--t1msk|-k) or --TnbtrFSL or --TnbtrCNS needs to be specified."
	echo
	usage
	exit 1

fi

# ========= if null assign default values =========== #

if [ -z ${Wintp:+a} ]; then
	Wintp="nn"
fi

if [ -z ${Wstt:+a} ]; then
	Wstt=0
fi

if [ -z ${Wend:+a} ]; then
	Wend=0
fi

if [ -z ${Wdof:+a} ]; then
	Wdof=6
fi

if [ -z ${Rintp:+a} ]; then
	Rintp="nearestneighbour"
fi

if [ -z ${Rstt:+a} ]; then
	Rstt=0
fi

if [ -z ${Rend:+a} ]; then
	Rend=0
fi

if [ -z ${Rdof:+a} ]; then
	Rdof=7
fi


# =========== Whether NBTR T1 ============== #
T1_folder=$(dirname "${T1}")
T1_filename=`echo $(basename "${T1}") | awk -F'.' '{print $1}'`

if [ ! -z ${T1mask:+a} ]; then

	# T1 mask is passed as argument
	T1mask_toUse=${T1mask}

elif [ "${Tnbtr}" = "FSL" ]; then

	# run bet T1
	bet ${T1} \
		${T1_folder}/${T1_filename}_brain \
		-f ${Tfi} \
		-m

	T1mask_toUse="${T1_folder}/${T1_filename}_brain_mask.nii.gz"

elif [ "${Tnbtr}" = "CNS" ]; then

	if [ "${T1##*.}" = "gz" ]; then
		gunzip ${T1}
	fi

	T1_nii="${T1_folder}/${T1_filename}.nii"

	# run CNS NBTR T1
	matlab -nodisplay -nosplash -nojvm -r "addpath ('${Scripts_folder}'); \
										   [cGM,cWM,cCSF,rcGM,rcWM,rcCSF] \
										   			= CNSP_segmentation ('${T1_nii}', '${Nspm12path}'); \
										   	CNSP_NBTRn ('${T1_nii}', \
										   	            cGM, \
										   	            cWM, \
										   	            cCSF, \
										   	            '${T1_folder}/${T1_filename}_brain', \
										   	            'maskout'); \
										   	exit"

	T1mask_toUse="${T1_folder}/${T1_filename}_brain_mask.nii.gz"

	gzip ${T1_nii}
fi

# get T1 brain
fslmaths ${T1} \
		 -mas ${T1mask_toUse} \
		 ${T1_folder}/${T1_filename}_brain

T1_brain=${T1_folder}/${T1_filename}_brain.nii.gz


# =========== Whether NBTR native image ============== #
if [ "${Nnbtr}" = "OFF" ]; then

	echo "[WARNING]: No NBTR on native image is specified. If your native image is head, rather than brain, please use --NnbtrFSL or --NnbtrCNS."
	
	# native image is passed as brain, rather than head
	native_toUse=${nativeImg}

elif [ "${Nnbtr}" = "FSL" ]; then

	# run bet native
	nativeImg_folder=$(dirname "${nativeImg}")
	nativeImg_filename=`echo $(basename "${nativeImg}") | awk -F'.' '{print $1}'`

	bet ${nativeImg} \
		${nativeImg_folder}/${nativeImg_filename}_brain \
		-f ${Nfi}

	native_toUse="${nativeImg_folder}/${nativeImg_filename}_brain.nii.gz"

elif [ "${Nnbtr}" = "CNS" ]; then

	if [ "${nativeImg##*.}" = "gz" ]; then
		gunzip ${nativeImg}
	fi

	if [ "${T1##*.}" = "gz" ]; then
		gunzip ${T1}
	fi

	T1_folder=$(dirname "${T1}")
	T1_filename=`echo $(basename "${T1}") | awk -F'.' '{print $1}'`

	T1_nii="${T1_folder}/${T1_filename}.nii"

	nativeImg_folder=$(dirname "${nativeImg}")
	nativeImg_filename=`echo $(basename "${nativeImg}") | awk -F'.' '{print $1}'`

	nativeImg_nii="${nativeImg_folder}/${nativeImg_filename}.nii"

	# run CNS NBTR

	# matlab -nodisplay -nosplash -nojvm -r "addpath ('${Scripts_folder}'); \
	# 									   [cGM,cWM,cCSF,rcGM,rcWM,rcCSF] \
	# 									   			= CNSP_segmentation ('${T1_nii}', '${Nspm12path}'); \
	# 									   	CNSP_NBTRn ('${T1_nii}', \
	# 									   	            cGM, \
	# 									   	            cWM, \
	# 									   	            cCSF, \
	# 									   	            '${T1_folder}/${T1_filename}_brain', \
	# 									   	            'maskout'); \
	# 									   	T1mask='${T1_folder}/${T1_filename}_brain_mask.nii.gz';\
	# 									   	system (['gunzip ' T1mask]);\
	# 									   	T1mask='${T1_folder}/${T1_filename}_brain_mask.nii';\
	# 									   	CNSP_reverse_registration_wMx ('${nativeImg_nii}', '${T1_nii}', T1mask);\
	# 									   	exit"


	# piggyback T1 mask
	matlab -nodisplay -nosplash -nojvm -r "addpath ('${Scripts_folder}', '${Nspm12path}'); \
										   	system ('cp ${T1mask_toUse} ${T1_folder}/${T1_filename}_brain_mask_copy.nii.gz');\
										   	T1mask_copy='${T1_folder}/${T1_filename}_brain_mask_copy.nii.gz';\
										   	system (['gunzip -f ' T1mask_copy]);\
										   	T1mask_copy='${T1_folder}/${T1_filename}_brain_mask_copy.nii';\
										   	CNSP_reverse_registration_wMx ('${nativeImg_nii}', '${T1_nii}', T1mask_copy);\
										   	exit"

	mv ${T1_folder}/r${T1_filename}_brain_mask_copy.nii ${nativeImg_folder}/${nativeImg_filename}_brain_mask.nii
	gzip -f ${nativeImg_folder}/${nativeImg_filename}_brain_mask.nii

	fslmaths ${nativeImg_folder}/${nativeImg_filename}_brain_mask.nii.gz \
			 -nan \
			 ${nativeImg_folder}/${nativeImg_filename}_brain_mask.nii.gz
								   	
	native_mask="${nativeImg_folder}/${nativeImg_filename}_brain_mask.nii.gz"

	gzip ${T1_nii} ${nativeImg_nii}

	fslmaths ${nativeImg} -mas ${native_mask} ${nativeImg_folder}/${nativeImg_filename}_brain

	native_toUse="${nativeImg_folder}/${nativeImg_filename}_brain.nii.gz"
fi




# ============= Start doing the job ================= #

# MNI-T1 reverse warping
fslcpgeom ${T1} ${T1mask_toUse} # otherwise fnirt complain about different dimension between T1 and mask

${Scripts_folder}/CNSP_reverse_warping_wMx_FSLfnirt.sh ${T1} \
													   ${T1mask_toUse} \
													   ${atlas} \
													   ${Wintp} \
													   ${Wstt} \
													   ${Wend} \
													   ${Wdof}

T1_folder=$(dirname "${T1}")
atlas_filename=`echo $(basename "${atlas}") | awk -F'.' '{print $1}'`

mv ${T1_folder}/${atlas_filename}_inverseXformed.nii.gz \
   ${Odir}/${Onam}_T1atlas.nii.gz


# T1-native reverse registration
${Scripts_folder}/CNSP_reverse_registration_wMx_FSLflirt.sh ${T1_brain} \
															${native_toUse} \
															${Odir}/${Onam}_T1atlas.nii.gz \
															${Odir} \
															${Rintp} \
															${Rstt} \
															${Rend} \
															${Rdof}

mv ${Odir}/otherImg_in_srcImgSpace.nii.gz ${Odir}/${Onam}_native_mask.nii.gz





