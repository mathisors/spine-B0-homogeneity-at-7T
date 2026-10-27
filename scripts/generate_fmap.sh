PROJECT=/home/mathi/projects/acdc_SMS
DATA=/home/mathi/projects/fmri_7T/ds007067
OUT=$PROJECT/7T_output/fig_output
SUBJECTS="sub-093 sub-094 sub-095 sub-096 sub-098 sub-099 sub-100 sub-101 sub-102 sub-103 sub-104 sub-105 sub-106 sub-107"


for SUB in $SUBJECTS; do
    echo "=========== $SUB ==========="
    IN=$DATA/$SUB
    ANAT=${IN}/anat/${SUB}_T2star.nii.gz
    PHASEDIFF=${IN}/fmap/${SUB}_phasediff.nii.gz
    #sct_deepseg spinalcord -i $ANAT -o $IN/anat/Mask.nii.gz
    #sct_create_mask -i $ANAT -p centerline,$IN/anat/Mask.nii.gz -size 20 -f cylinder -o $IN/anat/Mask_sct.nii.gz
    #sct_maths -i $IN/anat/Mask_sct.nii.gz -mul 1 -type uint8 -o $IN/anat/Mask_sct.nii.gz
    sct_maths -i $IN/anat/Mask_sct.nii.gz -shape cube -dilate 45 -type uint8 -o $IN/anat/Mask_dilate.nii.gz
    MAG1=${IN}/fmap/${SUB}_magnitude1.nii.gz
    MAG2=${IN}/fmap/${SUB}_magnitude2.nii.gz
    PHASEDIFF=${IN}/fmap/${SUB}_phasediff.nii.gz
    MASK=${IN}/anat/Mask_dilate.nii.gz

    st_prepare_fieldmap $PHASEDIFF \
        --mag "$MAG1" \
        --output "$DATA/$SUB/fmap/fmap.nii.gz" \
        --threshold 0.008 \
        --gaussian-filter True \
        --sigma 1 \
        --mask "$MASK" \

done